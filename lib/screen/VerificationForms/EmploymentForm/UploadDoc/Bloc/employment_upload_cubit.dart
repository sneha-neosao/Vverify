import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_verify/screen/VerificationForms/EmploymentForm/UploadDoc/Bloc/employment_upload_state.dart';
import '../../../../../apiServices/api_services.dart';



class EmploymentUploadCubit extends Cubit<EmploymentUploadState> {
  ApiService _apiService;

  EmploymentUploadCubit(this._apiService)
      : super(EmploymentUploadInitialState());

  void employmentUpload({required String token,
    required String customer_id,
    required String request_id,
    required String service_request_id,
    required File employment_supporting_doc,

  }) async {
    emit(EmploymentUploadLoadingState());
    try {
      final response = await _apiService.EmploymentSaveDoc(
          token: token,
          customer_id: customer_id,
          request_id: request_id,
          service_request_id: service_request_id,
          employment_supporting_doc: employment_supporting_doc);
      if (response.data != null && response.data.containsKey("status")) {
        if (response.data["status"] == 200) {
          emit(EmploymentUploadSuccessState(response.data));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(EmploymentUploadErrorState(errorMessage));
        } else {
          emit(EmploymentUploadErrorState('${response.data["message"]}'));
        }
      } else {
        emit(EmploymentUploadErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(EmploymentUploadErrorState('An error occurred:$e'));
    }
  }
}
