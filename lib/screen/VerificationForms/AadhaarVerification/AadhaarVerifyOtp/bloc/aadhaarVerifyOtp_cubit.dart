import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../apiServices/api_services.dart';
import 'aadhaarVerifyOtp_state.dart';

class AadhaarVerifyOtpCubit extends Cubit<AadhaarVerifyOtpState> {
  ApiService _apiService;

  AadhaarVerifyOtpCubit(this._apiService)
      : super(AadhaarVerifyOtpInitialState());

  void aadhaarVerifyOtp(
      {
        required String token,
        required String customerId,
      required String serviceRequestId,
      required String requestId,
      required String aadhaarNumber,
      required String otp}) async {
    emit(AadhaarVerifyOtpLoadingState());
    try {
      final response = await _apiService.AadhaarVerifyOtp(
        token: token,
        serviceRequestId: serviceRequestId,
        aadhaarNumber: aadhaarNumber,
        otp: otp, requestId: requestId, customerId: customerId,
      );

      if (response.data != null && response.data.containsKey("status")) {
        if (response.data["status"] == 200) {
          emit(AadhaarVerifyOtpSuccessState(response.data));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(AadhaarVerifyOtpErrorState(errorMessage));
        } else {
          emit(AadhaarVerifyOtpErrorState(
              '${response.data["message"]}'));
        }
      } else {
        emit(AadhaarVerifyOtpErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(AadhaarVerifyOtpErrorState('An error occurred:$e'));
    }
  }
}
