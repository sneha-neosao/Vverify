import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_verify/apiServices/api_services.dart';
import 'package:v_verify/screen/VerificationForms/EducationVerification/Documents/Blocs/education_document_list_bloc/education_doc_list_state.dart';
import 'package:v_verify/screen/VerificationForms/EducationVerification/Documents/Models/education_document_model.dart';
import 'package:v_verify/screen/VerificationForms/EmploymentVerification/Documents/Blocs/employment_document_list_bloc/employment_doc_list_state.dart';
import 'package:v_verify/screen/VerificationForms/EmploymentVerification/Documents/Models/employment_document_model.dart';


class EmploymentDocumentListCubit extends Cubit<EmploymentDocumentListState> {
  final ApiService _apiService;

  EmploymentDocumentListCubit(this._apiService)
      : super(EmploymentDocumentListInitialState());

  void loadEmploymentDocumentList({
    required String token,
    required String caseUuid,
    required String type, // usually "education"
  }) async {
    emit(EmploymentDocumentListLoadingState());
    try {
      final response = await _apiService.employmentDocumentList(
        token: token,
        caseUuid: caseUuid,
        type: type,
      );

      if (response.data != null && response.data.containsKey("status")) {
        EmploymentDocumentsModel employmentDocumentListModel =
        EmploymentDocumentsModel.fromJson(response.data);

        if (response.data["status"] == 200) {
          emit(EmploymentDocumentListSuccessState(employmentDocumentListModel));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(EmploymentDocumentListErrorState(errorMessage));
        } else {
          emit(EmploymentDocumentListErrorState('${response.data["message"]}'));
        }
      } else {
        emit(EmploymentDocumentListErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(EmploymentDocumentListErrorState('An error occurred: $e'));
    }
  }
}
