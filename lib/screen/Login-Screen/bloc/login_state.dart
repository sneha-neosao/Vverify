import 'package:equatable/equatable.dart';
import 'package:v_verify/screen/Login-Screen/model/login_model.dart';

class LoginState extends Equatable {
  @override
  List<Object?> get props => [];
}

class loginInitialState extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final LoginModel loginModel;

  LoginSuccess(this.loginModel);

  @override
  List<Object?> get props => [loginModel];
}

class LoginError extends LoginState {
  final String errorMessage;

  LoginError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
