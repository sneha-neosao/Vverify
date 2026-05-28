import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../apiServices/api_services.dart';
import 'gst_verification_show_state.dart';

class GstVerificationShowCubit extends Cubit<GstVerificationShowState> {
  final ApiService _apiService;

  GstVerificationShowCubit(this._apiService) : super(GstVerificationShowInitialState());

  void fetchGstDetails({
    required String token,
    required String uid,
  }) async {
    emit(GstVerificationShowLoadingState());
    try {
      final response = await _apiService.showGstVerification(
        token: token,
        uid: uid,
      );

      if (response.data != null && response.data.containsKey("status")) {
        if (response.data["status"] == 200) {
          emit(GstVerificationShowSuccessState(response.data));
        } else if (response.data["status"] == 500) {
          final errorMessage = response.data['message'] ?? 'Unknown error occurred.';
          emit(GstVerificationShowFailureState(errorMessage));
        } else {
          emit(GstVerificationShowFailureState(
              '${response.data["status"]} \n ${response.data["message"]}'));
        }
      } else {
        emit(GstVerificationShowFailureState('Invalid response data.'));
      }
    } catch (e) {
      emit(GstVerificationShowFailureState('An error occurred: $e'));
    }
  }
}
