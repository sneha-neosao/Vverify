import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_verify/screen/VerificationForms/PoliceVerification/NonMumbai/UpdateDocument/Bloc/update_documents_non_mumbai_state.dart';
import '../../../../../../apiServices/api_services.dart';
import '../model/documents_update_model.dart';

class UpdateDocumentsNonMumbaiCubit extends Cubit<UpdateDocumentsNonMumbaiState> {
  ApiService _apiService;

  UpdateDocumentsNonMumbaiCubit(this._apiService)
      : super(UpdateDocumentsNonMumbaiInitialState());

  void updateDocumentsNonMumbai(
      {
        required String customer_id,
        required String token,
      required UpdateDocumentsNonMumbaiModel
          updateDocumentsNonMumbaiModel}) async {
    emit(UpdateDocumentsNonMumbaiLoadingState());
    try {
      final response = await _apiService.tenantNonMumbaiUpdateDocuments(
        customer_id: customer_id,
        token: token,
        updateDocumentsNonMumbaiModel: updateDocumentsNonMumbaiModel,
      );

      if (response.data != null && response.data.containsKey("status")) {
        if (response.data["status"] == 200) {
          emit(UpdateDocumentsNonMumbaiSuccessState(response.data));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(UpdateDocumentsNonMumbaiErrorState(errorMessage));
        } else {
          emit(UpdateDocumentsNonMumbaiErrorState(
              'uploadDocuments failed with status: ${response.data["status"]}'));
        }
      } else {
        emit(UpdateDocumentsNonMumbaiErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(UpdateDocumentsNonMumbaiErrorState('An error occurred:$e'));
    }
  }
}
