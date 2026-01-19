import 'package:equatable/equatable.dart';

class CheckOutState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CheckOutInitialState extends CheckOutState {}

class CheckOutLoadingState extends CheckOutState {}

class CheckOutSuccessState extends CheckOutState {
  // final CheckoutModel checkoutModel;
  //
  // CheckOutSuccessState(this.checkoutModel);
  //
  // @override
  // List<Object?> get props => [checkoutModel];

  final String success;
  CheckOutSuccessState(this.success);
@override
List<Object?> get props => [success];

}

class CheckOutErrorState extends CheckOutState {
  final String errorMessage;

  CheckOutErrorState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
