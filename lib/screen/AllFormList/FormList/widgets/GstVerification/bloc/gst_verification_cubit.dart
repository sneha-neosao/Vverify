import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../apiServices/api_services.dart';
import 'gst_verification_state.dart';

class GstVerificationCubit extends Cubit<GstVerificationState> {
  final ApiService _apiService;

  GstVerificationCubit(this._apiService) : super(GstVerificationInitialState());

  void storeGst({
    required String token,
    required int requestId,
    required int serviceRequestId,
    required int customerId,
    required String gstNumber,
  }) async {
    emit(GstVerificationLoadingState());
    try {
      final response = await _apiService.storeGstVerification(
        token: token,
        requestId: requestId,
        serviceRequestId: serviceRequestId,
        customerId: customerId,
        gstNumber: gstNumber,
      );

      if (response.data != null && response.data.containsKey("status")) {
        if (response.data["status"] == 200) {
          final uid = response.data["uid"]?.toString() ?? "";
          emit(GstVerificationSuccessState(
              responseData: response.data, uid: uid));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(GstVerificationFailureState(errorMessage));
        } else {
          emit(GstVerificationFailureState(
              '${response.data["status"]} \n ${response.data["message"]}'));
        }
      } else {
        emit(GstVerificationFailureState('Invalid response data.'));
      }
    } catch (e) {
      emit(GstVerificationFailureState('An error occurred: $e'));
    }
  }

  void reset() {
    emit(GstVerificationInitialState());
  }
}
