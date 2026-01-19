import 'package:equatable/equatable.dart';
import 'package:v_verify/screen/ServicesAndPrice/Models/apply_coupon_model.dart';

class ApplyCouponState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ApplyCouponInitialState extends ApplyCouponState {}

class ApplyCouponLoadingState extends ApplyCouponState {}

class ApplyCouponSuccessState extends ApplyCouponState {
  final ApplyCouponModel applyCouponModel;

  ApplyCouponSuccessState(this.applyCouponModel);

  @override
  List<Object?> get props => [applyCouponModel];
}

class ApplyCouponErrorState extends ApplyCouponState {
  String message;

  ApplyCouponErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
