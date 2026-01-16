import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_verify/apiServices/api_services.dart';
import 'package:v_verify/screen/VerificationForms/AddressVerificationForm/Documents/Blocs/address_document_list_bloc/address_doc_list_state.dart';
import 'package:v_verify/screen/VerificationForms/AddressVerificationForm/Documents/Models/address_document_model.dart';

class AddressDocumentListCubit extends Cubit<AddressDocumentListState> {
  final ApiService _apiService;

  AddressDocumentListCubit(this._apiService)
      : super(AddressDocumentListInitialState());

  void loadAddressDocumentList({
    required String token,
    required String caseUuid,
    required String type, // usually "education"
  }) async {
    emit(AddressDocumentListLoadingState());
    try {
      final response = await _apiService.educationDocumentList(
        token: token,
        caseUuid: caseUuid,
        type: type,
      );

      if (response.data != null && response.data.containsKey("status")) {
        AddressDocumentsModel addressDocumentsModel =
        AddressDocumentsModel.fromJson(response.data);

        if (response.data["status"] == 200) {
          emit(AddressDocumentListSuccessState(addressDocumentsModel));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(AddressDocumentListErrorState(errorMessage));
        } else {
          emit(AddressDocumentListErrorState('${response.data["message"]}'));
        }
      } else {
        emit(AddressDocumentListErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(AddressDocumentListErrorState('An error occurred: $e'));
    }
  }
}
