import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../apiServices/api_services.dart';
import 'employ_doc_update_state.dart';

class EmployDocUpdateCubit extends Cubit<EmployDocUpdateState> {
  ApiService _apiService;

  EmployDocUpdateCubit(this._apiService)
      : super(EmployDocUpdateInitialState());

  void employmentUpdateDoc({required String token,
    required String request_id,
    required String customer_id,
    required String uid,
    required String service_request_id,
    required File employment_letter_doc,
    required File employment_supporting_doc,

  }) async {
    emit(EmployDocUpdateLoadingState());
    try {
      final response = await _apiService.employmentUpdateDoc(
          customer_id: customer_id,
          token: token,
          uid: uid,
          request_id: request_id,
          service_request_id: service_request_id,
          employment_letter_doc: employment_letter_doc,
          employment_supporting_doc: employment_supporting_doc);
      if (response.data != null && response.data.containsKey("status")) {
        if (response.data["status"] == 200) {
          emit(EmployDocUpdateSuccessState(response.data));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(EmployDocUpdateErrorState(errorMessage));
        } else {
          emit(EmployDocUpdateErrorState('${response.data["message"]}'));
        }
      } else {
        emit(EmployDocUpdateErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(EmployDocUpdateErrorState('An error occurred:$e'));
    }
  }
}