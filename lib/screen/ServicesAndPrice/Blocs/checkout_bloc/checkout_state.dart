import 'package:equatable/equatable.dart';
import 'package:v_verify/screen/ServicesAndPrice/Models/checkout_model.dart';

class CheckOutState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CheckOutInitialState extends CheckOutState {}

class CheckOutLoadingState extends CheckOutState {}

class CheckOutSuccessState extends CheckOutState {
  final CheckoutModel checkoutModel;

  CheckOutSuccessState(this.checkoutModel);

  @override
  List<Object?> get props => [checkoutModel];
}

class CheckOutErrorState extends CheckOutState {
  final String errorMessage;

  CheckOutErrorState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
