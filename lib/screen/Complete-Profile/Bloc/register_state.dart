import 'package:equatable/equatable.dart';
import 'package:v_verify/screen/Complete-Profile/model/register_model.dart';

class RegisterState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RegisterInitialState extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final RegisterModel registerModel;

  RegisterSuccess(this.registerModel);

  @override
  List<Object?> get props => [registerModel];
}

class RegisterError extends RegisterState {
  final String errorMessage;

  RegisterError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
