import 'package:equatable/equatable.dart';

class SignOutState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SignOutInitial extends SignOutState {}

class SignOutLoading extends SignOutState {}

class SignOutSuccess extends SignOutState {}

class SignOutError extends SignOutState {
  final String errorMessage;

  SignOutError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
