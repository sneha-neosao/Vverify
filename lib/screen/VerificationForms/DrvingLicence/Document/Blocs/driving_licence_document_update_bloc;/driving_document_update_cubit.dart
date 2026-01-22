import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_verify/apiServices/api_services.dart';
import 'driving_document_update_state.dart';

class DrivingDocUpdateCubit extends Cubit<DrivingDocUpdateState> {
  ApiService _apiService;

  DrivingDocUpdateCubit(this._apiService)
      : super(DrivingDocUpdateInitialState());

  void drivingLicenceDocUpdateData({
    required String customer_id,
    required String token,
    required String request_id,
    required String service_request_id,
    required File data_document,
  }) async {
    emit(DrivingDocUpdateLoadingState());
    try {
      final response = await _apiService.drivingDocUpdate(
        customer_id: customer_id,
        token: token,
        request_id: request_id,
        service_request_id: service_request_id,
        data_document: data_document,
      );

      if (response.data != null && response.data.containsKey("status")) {
        if (response.data["status"] == 200) {
          emit(DrivingDocUpdateSuccessState(response.data));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(DrivingDocUpdateErrorState(errorMessage));
        } else {
          emit(DrivingDocUpdateErrorState('${response.data["message"]}'));
        }
      } else {
        emit(DrivingDocUpdateErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(DrivingDocUpdateErrorState('An error occurred:$e'));
    }
  }
}
