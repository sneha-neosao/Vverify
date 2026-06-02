import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_verify/apiServices/api_services.dart';
import 'package:v_verify/screen/PushNotification/Bloc/push_notification_state.dart';

class PushNotificationCubit extends Cubit<PushNotificationState> {
  final ApiService _apiService;

  PushNotificationCubit(this._apiService)
      : super(PushNotificationInitialState());

  void pushNotification({
    required String token,
    required String customerId,
    required String firebaseId,
    required String os_version,
    required String app_version,
    required String mobile_model,
    required String device_type,
  }) async {
    emit(PushNotificationLoadingState());
    try {
      final response = await _apiService.pushNotificationApi(
          token: token,
          customer_id: customerId,
          firebase_id: firebaseId,
          os_version: os_version,
          app_version: app_version,
          mobile_model: mobile_model,
          device_type: device_type);

      if (response.data != null && response.data.containsKey("status")) {
        if (response.data["status"] == 200) {
          emit(PushNotificationSuccessState(response.data));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(PushNotificationErrorState(errorMessage));
        } else {
          emit(PushNotificationErrorState('${response.data["message"]}'));
        }
      } else {
        emit(PushNotificationErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(PushNotificationErrorState('An error occurred:$e'));
    }
  }
}
