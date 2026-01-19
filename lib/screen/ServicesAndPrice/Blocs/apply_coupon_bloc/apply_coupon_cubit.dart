import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_verify/screen/ServicesAndPrice/Models/apply_coupon_model.dart';
import '../../../../../../apiServices/api_services.dart';
import 'apply_coupon_state.dart';

class ApplyCouponCubit extends Cubit<ApplyCouponState> {
  ApiService _apiService;

  ApplyCouponCubit(this._apiService)
      : super(ApplyCouponInitialState());

  void applyCoupon(
      {
        required String token,
        required String customer_id,
        required String subtotal,
        required String coupon_code
      }) async {
    emit(ApplyCouponLoadingState());
    try {
      final response = await _apiService.applyCoupon(
        token: token,
        customer_id: customer_id,
        subtotal: subtotal,
        coupon_code: coupon_code,
      );
      if (response.data != null && response.data.containsKey("status")) {
        if (response.data["status"] == 200) {
          ApplyCouponModel applyCouponModel = ApplyCouponModel.fromJson(response.data);
          emit(ApplyCouponSuccessState(applyCouponModel));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(ApplyCouponErrorState(errorMessage));
        } else {
          emit(ApplyCouponErrorState('${response.data["message"]}'));
        }
      } else {
        emit(ApplyCouponErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(ApplyCouponErrorState('An error occurred:$e'));
    }
  }
}
