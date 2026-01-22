import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_verify/apiServices/api_services.dart';
import 'package:v_verify/screen/VerificationForms/DrvingLicence/Form/Blocs/driving_licence_update_bloc/driving_licence_update_form_state.dart';

class DrivingLicenceUpdateCubit extends Cubit<DrivingLicenceUpdateState> {
  ApiService _apiService;

  DrivingLicenceUpdateCubit(this._apiService)
      : super(DrivingLicenceUpdateInitialState());

  void drivingLicenceUpdateData(
      {
        required String customer_id,
        required String token,
      required String request_id,
      required String service_request_id,
      required String driver_licence_number,
      required String dob,
      String? status}) async {
    emit(DrivingLicenceUpdateLoadingState());
    try {
      final response = await _apiService.drivingLicenceUpdate(
        customer_id: customer_id,
        token: token,
        request_id: request_id,
        service_request_id: service_request_id,
        driver_licence_number: driver_licence_number,
        dob: dob,
      );

      if (response.data != null && response.data.containsKey("status")) {
        if (response.data["status"] == 200) {
          emit(DrivingLicenceUpdateSuccessState(response.data));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(DrivingLicenceUpdateErrorState(errorMessage));
        } else {
          emit(DrivingLicenceUpdateErrorState('${response.data["message"]}'));
        }
      } else {
        emit(DrivingLicenceUpdateErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(DrivingLicenceUpdateErrorState('An error occurred:$e'));
    }
  }
}
