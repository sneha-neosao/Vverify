import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_verify/apiServices/api_services.dart';
import 'package:v_verify/screen/VerificationPending/verifyRequestUpdate/Bloc/verify_request_update_state.dart';

class VerifyRequestUpdateCubit extends Cubit<VerifyRequestUpdateState> {
  ApiService _apiService;

  VerifyRequestUpdateCubit(this._apiService)
      : super(VerifyRequestUpdateInitialState());

  void verifyRequestUpdate(
      {required String token,
      required String uuid,
      required String firstName,
      required String middleName,
      required String lastName,
      required String phone,
      required String dob,
      required String email,
      required String employee_code,
      required String date_of_joining,
      required String gender,
      String? status}) async {
    emit(VerifyRequestUpdateLoadingState());
    try {
      final response = await _apiService.verifyRequestUpdate(
        token: token,
        uuid: uuid,
        phone: phone,
        dob: dob,
        firstName: firstName,
        middleName: middleName,
        lastName: lastName,
        email: email,
        employee_code: employee_code,
        date_of_joining: date_of_joining,
        gender: gender
      );

      if (response.data != null && response.data.containsKey("status")) {
        if (response.data["status"] == 200) {
          emit(VerifyRequestUpdateSuccessState(response.data));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(VerifyRequestUpdateErrorState(errorMessage));
        } else {
          emit(VerifyRequestUpdateErrorState('${response.data["message"]}'));
        }
      } else {
        emit(VerifyRequestUpdateErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(VerifyRequestUpdateErrorState('An error occurred:$e'));
    }
  }
}
