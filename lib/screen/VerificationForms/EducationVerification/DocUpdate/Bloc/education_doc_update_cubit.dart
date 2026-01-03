import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../apiServices/api_services.dart';
import 'education_doc_update_state.dart';


class EducationDocUpdateCubit extends Cubit<EducationDocUpdateState> {
  ApiService _apiService;

  EducationDocUpdateCubit(this._apiService)
      : super(EducationDocUpdateInitialState());

  void educationDocUpdate({
    required String token,
    required String customer_id,
    required String uid,
    required String request_id,
    required String service_request_id,
    required File document,
  }) async {
    emit(EducationDocUpdateLoadingState());
    try {
      final response = await _apiService.EducationDocUpdate(
        customer_id: customer_id,
        token: token,
        request_id: request_id,
        service_request_id: service_request_id,
        document: document,
        uid: uid,
      );
      if (response.data != null && response.data.containsKey("status")) {
        if (response.data["status"] == 200) {
          emit(EducationDocUpdateSuccessState(response.data));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(EducationDocUpdateErrorState(errorMessage));
        } else {
          emit(EducationDocUpdateErrorState('${response.data["message"]}'));
        }
      } else {
        emit(EducationDocUpdateErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(EducationDocUpdateErrorState('An error occurred:$e'));
    }
  }
}
