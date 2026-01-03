import 'package:equatable/equatable.dart';

class AadhaarVerifyOtpState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AadhaarVerifyOtpInitialState extends AadhaarVerifyOtpState {}

class AadhaarVerifyOtpLoadingState extends AadhaarVerifyOtpState {}

class AadhaarVerifyOtpSuccessState extends AadhaarVerifyOtpState {
  final Map<String, dynamic> data;

  AadhaarVerifyOtpSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class AadhaarVerifyOtpErrorState extends AadhaarVerifyOtpState {
  String message;

  AadhaarVerifyOtpErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
