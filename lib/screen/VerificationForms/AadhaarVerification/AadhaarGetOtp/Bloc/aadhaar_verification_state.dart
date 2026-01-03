import 'package:equatable/equatable.dart';

class AadhaarGetOtpState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AadhaarGetOtpStateInitialState
    extends AadhaarGetOtpState {}

class AadhaarGetOtpStateLoadingState
    extends AadhaarGetOtpState {}

class AadhaarGetOtpStateSuccessState extends AadhaarGetOtpState {
  final Map<String,dynamic> data;

  AadhaarGetOtpStateSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class AadhaarGetOtpStateErrorState extends AadhaarGetOtpState {
  String message;

  AadhaarGetOtpStateErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
