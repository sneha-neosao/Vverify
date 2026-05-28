import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../apiServices/api_services.dart';
import 'credit_history_state.dart';

class CreditHistoryCubit extends Cubit<CreditHistoryState> {
  final ApiService _apiService;

  CreditHistoryCubit(this._apiService) : super(CreditHistoryInitialState());

  void sendOtp({
    required String token,
    required String mobileNumber,
    String type = "",
  }) async {
    emit(CreditHistoryOtpLoadingState());
    try {
      final response = await _apiService.sendCreditReportOtp(
        token: token,
        mobileNumber: mobileNumber,
        type: type,
      );

      if (response.data != null && response.data.containsKey("status")) {
        if (response.data["status"] == 200) {
          final otpRefId = response.data["otpRefId"]?.toString() ?? "";
          final message = response.data["message"]?.toString() ?? "OTP sent successfully";
          emit(CreditHistoryOtpSuccessState(otpRefId: otpRefId, message: message));
        } else if (response.data["status"] == 500) {
          final errorMessage = response.data['message'] ?? 'Unknown error occurred.';
          emit(CreditHistoryOtpFailureState(errorMessage));
        } else {
          emit(CreditHistoryOtpFailureState(
              '${response.data["status"]} \n ${response.data["message"]}'));
        }
      } else {
        emit(CreditHistoryOtpFailureState('Invalid response data.'));
      }
    } catch (e) {
      emit(CreditHistoryOtpFailureState('An error occurred: $e'));
    }
  }

  void storeReport({
    required String token,
    required int requestId,
    required int serviceRequestId,
    required int customerId,
    required String firstName,
    required String lastName,
    required String mobileNumber,
    required String otp,
  }) async {
    emit(CreditHistoryStoreLoadingState());
    try {
      final response = await _apiService.storeCreditReport(
        token: token,
        requestId: requestId,
        serviceRequestId: serviceRequestId,
        customerId: customerId,
        firstName: firstName,
        lastName: lastName,
        mobileNumber: mobileNumber,
        otp: otp,
      );

      if (response.data != null && response.data.containsKey("status")) {
        if (response.data["status"] == 200) {
          final uid = response.data["uid"]?.toString() ?? "";
          emit(CreditHistoryStoreSuccessState(responseData: response.data, uid: uid));
        } else if (response.data["status"] == 500) {
          final errorMessage = response.data['message'] ?? 'Unknown error occurred.';
          emit(CreditHistoryStoreFailureState(errorMessage));
        } else {
          emit(CreditHistoryStoreFailureState(
              '${response.data["status"]} \n ${response.data["message"]}'));
        }
      } else {
        emit(CreditHistoryStoreFailureState('Invalid response data.'));
      }
    } catch (e) {
      emit(CreditHistoryStoreFailureState('An error occurred: $e'));
    }
  }

  void reset() {
    emit(CreditHistoryInitialState());
  }
}
