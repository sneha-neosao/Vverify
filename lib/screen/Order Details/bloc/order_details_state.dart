import 'package:equatable/equatable.dart';
import 'package:v_verify/screen/Order%20Details/model/order_details_model.dart';

class OrderDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class OrderDetailsInitialState extends OrderDetailsState {}

class OrderDetailsLoading extends OrderDetailsState {}

class OrderDetailsSuccess extends OrderDetailsState {
  final OrderDetailsModel orderDetailsModel;

  OrderDetailsSuccess(this.orderDetailsModel);

  @override
  List<Object?> get props => [orderDetailsModel];
}

class OrderDetailsError extends OrderDetailsState {
  final String errorMessage;

  OrderDetailsError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
