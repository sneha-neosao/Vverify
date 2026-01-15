import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_verify/apiServices/api_services.dart';
import 'package:v_verify/screen/VerificationForms/EducationVerification/Documents/Blocs/education_document_list_bloc/education_doc_list_state.dart';
import 'package:v_verify/screen/VerificationForms/EducationVerification/Documents/Models/education_document_model.dart';


class EducationDocumentListCubit extends Cubit<EducationDocumentListState> {
  final ApiService _apiService;

  EducationDocumentListCubit(this._apiService)
      : super(EducationDocumentListInitialState());

  void loadEducationDocumentList({
    required String token,
    required String caseUuid,
    required String type, // usually "education"
  }) async {
    emit(EducationDocumentListLoadingState());
    try {
      final response = await _apiService.educationDocumentList(
        token: token,
        caseUuid: caseUuid,
        type: type,
      );

      if (response.data != null && response.data.containsKey("status")) {
        EducationDocumentsModel educationDocumentListModel =
        EducationDocumentsModel.fromJson(response.data);

        if (response.data["status"] == 200) {
          emit(EducationDocumentListSuccessState(educationDocumentListModel));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(EducationDocumentListErrorState(errorMessage));
        } else {
          emit(EducationDocumentListErrorState('${response.data["message"]}'));
        }
      } else {
        emit(EducationDocumentListErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(EducationDocumentListErrorState('An error occurred: $e'));
    }
  }
}
