import 'package:equatable/equatable.dart';

class AadhaarVerifyState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AadhaarVerifyInitialState extends AadhaarVerifyState {}

class AadhaarVerifyLoadingState extends AadhaarVerifyState {}

class AadhaarVerifySuccessState extends AadhaarVerifyState {
  final Map<String, dynamic> responseData;

  AadhaarVerifySuccessState(this.responseData);

  @override
  List<Object?> get props => [responseData];
}

class AadhaarVerifyErrorState extends AadhaarVerifyState {
  final String message;

  AadhaarVerifyErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
