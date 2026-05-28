import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../apiServices/api_services.dart';
import 'aadhaar_verify_state.dart';

class AadhaarVerifyCubit extends Cubit<AadhaarVerifyState> {
  final ApiService _apiService;

  AadhaarVerifyCubit(this._apiService) : super(AadhaarVerifyInitialState());

  void verifyAadhaar({
    required String token,
    required int request_id,
    required int service_request_id,
    required int customer_id,
    required String aadhaar_number,
    required String status,
    required String unifiedTransactionId,
    required int service_id,
  }) async {
    emit(AadhaarVerifyLoadingState());
    try {
      final response = await _apiService.verifyAadharDigilocker(
        token: token,
        request_id: request_id,
        service_request_id: service_request_id,
        customer_id: customer_id,
        aadhaar_number: aadhaar_number,
        status: status,
        unifiedTransactionId: unifiedTransactionId,
        service_id: service_id,
      );

      if (response.data != null && response.data.containsKey("status")) {
        if (response.data["status"] == 200) {
          emit(AadhaarVerifySuccessState(response.data));
        } else if (response.data["status"] == 500) {
          final errorMessage = response.data['message'] ?? 'Unknown error occurred.';
          emit(AadhaarVerifyErrorState(errorMessage));
        } else {
          emit(AadhaarVerifyErrorState(
              '${response.data["status"]} \n ${response.data["message"]}'));
        }
      } else {
        emit(AadhaarVerifyErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(AadhaarVerifyErrorState('An error occurred: $e'));
    }
  }
}
