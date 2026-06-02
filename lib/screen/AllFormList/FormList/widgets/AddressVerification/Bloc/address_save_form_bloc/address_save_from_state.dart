import 'package:equatable/equatable.dart';

class NameAddressVerificationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NameAddressVerificationInitialState
    extends NameAddressVerificationState {}

class NameAddressVerificationLoadingState
    extends NameAddressVerificationState {}

class NameAddressVerificationSuccessState extends NameAddressVerificationState {
  final Map<String, dynamic> data;

  NameAddressVerificationSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class NameAddressVerificationErrorState extends NameAddressVerificationState {
  String message;

  NameAddressVerificationErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
