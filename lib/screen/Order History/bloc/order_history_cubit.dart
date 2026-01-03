
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../apiServices/api_services.dart';
import 'model/order_history_model.dart';
import 'order_history_state.dart';

class OrderHistoryCubit extends Cubit<OrderHistoryState> {

  final ApiService _apiService;
  OrderHistoryCubit(this._apiService) : super(OrderHistoryInitialState());

  void getOrderHistory({
    required String token,
    required int customerID,
    required int page,
    required int limit,
  }) async {
    try {
      emit(OrderHistoryLoading());
      final response = await _apiService.getTransactionList(
          token: token, customer_id: customerID, page: page, limit: limit);

      if (response.data != null && response.data.containsKey("status")) {
        final OrderHistoryModel orderHistoryModel =
            OrderHistoryModel.fromJson(response.data);
        if (orderHistoryModel.status == 200) {
          emit(OrderHistorySuccess(orderHistoryModel));
        } else if (orderHistoryModel.status == 300) {
          final errorMessage =
              response.data['message'];
          emit(OrderHistoryError(errorMessage));
        } else {
          emit(OrderHistoryError(
              'Profile failed with status: ${orderHistoryModel.status}'));
        }
      } else {
        emit(OrderHistoryError('Invalid response data.'));
      }
    } catch (e) {
      emit(OrderHistoryError('An error occurred:$e'));
    }
  }
}

// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../apiServices/api_services.dart';
// import '../model/order_history_model.dart';
// import 'order_history_state.dart';
//
// class PaginationCubit extends Cubit<PaginationState> {
//   final ApiService apiService;
//
//   PaginationCubit({required this.apiService}) : super(PaginationInitial());
//
//   // Fetch paginated data from the API
//   Future<void> fetchData({required int page}) async {
//     try {
//       // Emit loading state when a new page is requested
//       emit(PaginationLoading(page));
//       final List<DataModel> result = await apiService.fetchData(page);
//       print("result12 ${result}");
//       // Emit loaded state with the new data
//       if (result.isEmpty) {
//         print("enter noMore");
//         emit(PaginationNoMoreData(page));
//       } else {
//         print("enter load");
//         emit(PaginationLoaded(page, result));
//       }
//     } catch (e) {
//       // Emit error state if an error occurs
//       emit(PaginationError(e.toString()));
//     }
//   }
// }
