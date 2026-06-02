import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../apiServices/api_services.dart';
import 'checkout_status_checking_state.dart';

class CheckOutStatusCheckingCubit extends Cubit<CheckoutStatusCheckingState> {
  final ApiService _apiService;

  CheckOutStatusCheckingCubit(this._apiService)
      : super(CheckoutStatusCheckingInitialState());

  void checkoutStatusChecking({
    required String token,
    required String payment_order_id,
  }) async {
    emit(CheckoutStatusCheckingLoadingState());
    try {
      final response = await _apiService.getCheckOutStatus(
        token: token,
        payment_order_id: payment_order_id,
      );
      if (response.data != null && response.data.containsKey("status")) {
        if (response.data["status"] == 200) {
          emit(CheckoutStatusCheckingSuccessState(response.data));
        } else if (response.data["status"] == 500) {
          final errorMessage = response.data['message'];
          emit(CheckoutStatusCheckingErrorState(errorMessage));
        } else {
          emit(CheckoutStatusCheckingErrorState('${response.data["message"]}'));
        }
      } else {
        emit(CheckoutStatusCheckingErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(CheckoutStatusCheckingErrorState('An error occurred:$e'));
    }
  }
}
