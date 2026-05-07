import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_verify/apiServices/api_services.dart';
import 'package:v_verify/screen/ServicesAndPrice/Models/checkout_model.dart';
import 'package:v_verify/screen/ServicesAndPrice/Blocs/checkout_bloc/checkout_state.dart';

class CheckoutCubit extends Cubit<CheckOutState> {
  ApiService _apiService;

  CheckoutCubit(this._apiService) : super(CheckOutInitialState());

  void checkout({
    required String token,
    required int customer_id,
    required String payment_gateway,
    required String payment_mode,
    String? coupon_code,
    required List<Map<String, dynamic>> items,
  }) async {
    emit(CheckOutLoadingState());
    try {
      final response = await _apiService.getTransactionCheckout(
          token: token,
          customer_id: customer_id,
          payment_gateway: payment_gateway,
          payment_mode: payment_mode,
          coupon_code: coupon_code,
          items: items);

      if (response.data != null && response.data.containsKey("status")) {
        final status = response.data["status"];
        if (status == 200) {
          // Parse the response into CheckoutModel
          final checkoutModel = CheckoutModel.fromJson(response.data);
          emit(CheckOutSuccessState(checkoutModel));
        } else if (status == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(CheckOutErrorState(errorMessage));
        } else {
          emit(CheckOutErrorState('Failed with status: $status'));
        }
      } else {
        emit(CheckOutErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(CheckOutErrorState('An error occurred: ${e.toString()}'));
    }
  }
}