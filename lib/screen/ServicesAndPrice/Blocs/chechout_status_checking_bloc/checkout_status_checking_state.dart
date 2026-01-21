import 'package:equatable/equatable.dart';

class CheckoutStatusCheckingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CheckoutStatusCheckingInitialState extends CheckoutStatusCheckingState {}

class CheckoutStatusCheckingLoadingState extends CheckoutStatusCheckingState {}

class CheckoutStatusCheckingSuccessState extends CheckoutStatusCheckingState {
  final Map<String,dynamic> data;

  CheckoutStatusCheckingSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class CheckoutStatusCheckingErrorState extends CheckoutStatusCheckingState {
  String message;

  CheckoutStatusCheckingErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
