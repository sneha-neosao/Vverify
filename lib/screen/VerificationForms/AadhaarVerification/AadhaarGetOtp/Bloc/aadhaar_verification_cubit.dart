import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../apiServices/api_services.dart';
import 'aadhaar_verification_state.dart';

class AadhaarGetOtpCubit extends Cubit<AadhaarGetOtpState> {
  ApiService _apiService;

  AadhaarGetOtpCubit(this._apiService)
      : super(AadhaarGetOtpStateInitialState());

  void aadhaarSendOtpForm({
    required String token,
    required String serviceRequestId,
    required String requestId,
    required String customer_id,
    required String aadhaarNumber,
  }) async {
    emit(AadhaarGetOtpStateLoadingState());
    try {
      final response = await _apiService.AadhaarGetOtp(
        requestId: requestId,
        customer_id: customer_id,
        token: token,
        serviceRequestId: serviceRequestId,
        aadhaarNumber: aadhaarNumber,
      );

      if (response.data != null && response.data.containsKey("status")) {
        if (response.data["status"] == 200) {
          emit(AadhaarGetOtpStateSuccessState(response.data));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(AadhaarGetOtpStateErrorState(errorMessage));
        } else {
          emit(AadhaarGetOtpStateErrorState(
              '${response.data["status"]} \n ${response.data["message"]}'));
        }
      } else {
        emit(AadhaarGetOtpStateErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(AadhaarGetOtpStateErrorState('An error occurred:$e'));
    }
  }
}
