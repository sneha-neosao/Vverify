import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_verify/apiServices/api_services.dart';
import 'driving_licence_state.dart';

class DrivingLicenceBloc extends Cubit<DrivingLicenceState> {
  ApiService _apiService;

  DrivingLicenceBloc(this._apiService) : super(DrivingLicenceInitialState());

  void drivingLicenceSaveData(
      {
        required String token,
        required String customer_id,
      required String request_id,
      required String service_request_id,
      required String driver_licence_number,
      required String dob,
      String? status}) async {
    emit(DrivingLicenceLoadingState());
    try {
      final response = await _apiService.drivingLicenceSave(
        customer_id: customer_id,
        token: token,
        request_id: request_id,
        service_request_id: service_request_id,
        driver_licence_number: driver_licence_number,
        dob: dob,
      );

      if (response.data != null && response.data.containsKey("status")) {
        if (response.data["status"] == 200) {
          emit(DrivingLicenceSuccessState(response.data));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(DrivingLicenceErrorState(errorMessage));
        } else {
          emit(DrivingLicenceErrorState('${response.data["message"]}'));
        }
      } else {
        emit(DrivingLicenceErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(DrivingLicenceErrorState('An error occurred:$e'));
    }
  }
}
class FormUploadDrivingCubit extends Cubit<bool> {
  FormUploadDrivingCubit() : super(false);

  void formUploadYesNo({required bool yesNo}) {
    emit(yesNo);
  }
}