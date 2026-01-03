import 'package:equatable/equatable.dart';

import '../model/otpVerify_model.dart';

class OtpVerifyState extends Equatable {
  @override
  List<Object?> get props => [];
}

class OtpVerifyInitialState extends OtpVerifyState {}

class OtpVerifyLoading extends OtpVerifyState {}

class OtpVerifySuccess extends OtpVerifyState {
  final OtpVerifyModel otpVerifyModel;

  OtpVerifySuccess(this.otpVerifyModel);

  @override
  List<Object?> get props => [otpVerifyModel];
}

class OtpVerifyError extends OtpVerifyState {
  final String errorMessage;

  OtpVerifyError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
