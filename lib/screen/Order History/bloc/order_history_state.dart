import 'package:equatable/equatable.dart';
import 'model/order_history_model.dart';



class OrderHistoryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class OrderHistoryInitialState extends OrderHistoryState {}

class OrderHistoryLoading extends OrderHistoryState {}

class OrderHistorySuccess extends OrderHistoryState {
  final OrderHistoryModel orderHistoryModel;

  OrderHistorySuccess(this.orderHistoryModel);

  @override
  List<Object?> get props => [orderHistoryModel];
}

class OrderHistoryError extends OrderHistoryState {
  final String errorMessage;

  OrderHistoryError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}



// import 'package:flutter/material.dart';
//
// import '../model/order_history_model.dart';
//
// @immutable
// abstract class PaginationState {}
//
// class PaginationInitial extends PaginationState {}
//
// class PaginationLoading extends PaginationState {
//   final int page;
//   PaginationLoading(this.page);
// }
//
// class PaginationLoaded extends PaginationState {
//   final int page;
//   final List<DataModel> data;
//   PaginationLoaded(this.page, this.data);
// }
//
// class PaginationNoMoreData extends PaginationState {
//   final int page;
//   PaginationNoMoreData(this.page);
// }
//
// class PaginationError extends PaginationState {
//   final String message;
//   PaginationError(this.message);
// }
//
