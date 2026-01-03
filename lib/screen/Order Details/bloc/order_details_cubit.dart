import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_verify/apiServices/api_services.dart';
import 'package:v_verify/screen/Order%20Details/bloc/order_details_state.dart';
import 'package:v_verify/screen/Order%20Details/model/order_details_model.dart';

class OrderDetailsCubit extends Cubit<OrderDetailsState> {
  final ApiService _apiService;

  OrderDetailsCubit(this._apiService) : super(OrderDetailsInitialState());

  void getOrderDetails({
    required String token,
    required String txnId,
  }) async {
    emit(OrderDetailsLoading());
    try {
      final response =
          await _apiService.getTransactionDetails(token: token, txnId: txnId);

      if (response.data != null && response.data.containsKey("status")) {
        final OrderDetailsModel orderDetailsModel =
            OrderDetailsModel.fromJson(response.data);
        if (orderDetailsModel.status == 200) {
          emit(OrderDetailsSuccess(orderDetailsModel));
        } else if (orderDetailsModel.status == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(OrderDetailsError(errorMessage));
        } else {
          emit(OrderDetailsError(
              'Profile failed with status: ${orderDetailsModel.status}'));
        }
      } else {
        emit(OrderDetailsError('Invalid response data.'));
      }
    } catch (e) {
      emit(OrderDetailsError('An error occurred:$e'));
    }
  }
}
