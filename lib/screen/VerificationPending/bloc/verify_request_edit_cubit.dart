import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_verify/apiServices/api_services.dart';
import 'package:v_verify/screen/VerificationPending/bloc/verify_request_edit_state.dart';

class VerifyRequestEditCubit extends Cubit<VerifyRequestEditState> {
  ApiService _apiService;

  VerifyRequestEditCubit(this._apiService)
      : super(VerifyRequestEditInitialState());

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
    emit(VerifyRequestEditLoadingState());
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
          emit(VerifyRequestEditSuccessState(response.data));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(VerifyRequestEditErrorState(errorMessage));
        } else {
          emit(VerifyRequestEditErrorState('${response.data["message"]}'));
        }
      } else {
        emit(VerifyRequestEditErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(VerifyRequestEditErrorState('An error occurred:$e'));
    }
  }
}
