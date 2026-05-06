import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../apiServices/api_services.dart';
import '../model/otpVerify_model.dart';
import 'otpVerify_state.dart';

class OtpVerifyCubit extends Cubit<OtpVerifyState> {
  ApiService _apiService;

  OtpVerifyCubit(this._apiService) : super(OtpVerifyInitialState());

  void otpVerify({required String mobileNumber, required String otp}) async {
    emit(OtpVerifyLoading());
    try {
      final response =
          await _apiService.otpVerify(mobileNumber: mobileNumber, otp: otp);

      if (response.data != null && response.data.containsKey("status")) {
        final OtpVerifyModel otpVerifyModel =
            OtpVerifyModel.fromJson(response.data);
       // final status = response.data["status"];
          emit(OtpVerifySuccess(otpVerifyModel));
      } else {
        emit(OtpVerifyError('Invalid response data.'));
      }
    } catch (e) {
      emit(OtpVerifyError('An error occurred: ${e.toString()}'));
    }
  }

  void resendOtp({required String mobileNumber}) async {
    emit(ResendOtpLoading());
    try {
      final response = await _apiService.resendOtp(mobileNumber: mobileNumber);

      if (response.data != null && response.data.containsKey("status")) {
        if (response.data["status"] == 200) {
          emit(ResendOtpSuccess(response.data["message"] ?? 'OTP resend successfully.'));
        } else {
          emit(ResendOtpError(response.data["message"] ?? 'Failed to resend OTP.'));
        }
      } else {
        emit(ResendOtpError('Invalid response data.'));
      }
    } catch (e) {
      emit(ResendOtpError('An error occurred: ${e.toString()}'));
    }
  }
}

class TimerCubit extends Cubit<int> {
  Timer? _timer;

  // Initial state is 60 seconds
  TimerCubit() : super(60);

  // Method to start the timer
  void startTimer() {
    if (_timer != null && _timer!.isActive) return; // Prevent multiple timers

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state > 0) {
        emit(state - 1); // Emit the remaining time by decrementing it
      } else {
        _timer?.cancel(); // Stop the timer when it reaches 0
      }
    });
  }

  // Method to stop the timer
  void stopTimer() {
    _timer?.cancel();
    emit(60); // Reset to 60 seconds
  }

  // Method to reset the timer
  void resetTimer() {
    _timer?.cancel();
    emit(60); // Reset to 60 seconds
  }
}
