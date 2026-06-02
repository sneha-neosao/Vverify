import 'package:equatable/equatable.dart';

class VerifyRequestUpdateState extends Equatable {
  @override
  List<Object?> get props => [];
}

class VerifyRequestUpdateInitialState extends VerifyRequestUpdateState {}

class VerifyRequestUpdateLoadingState extends VerifyRequestUpdateState {}

class VerifyRequestUpdateSuccessState extends VerifyRequestUpdateState {
  final Map<String, dynamic> data;

  VerifyRequestUpdateSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class VerifyRequestUpdateErrorState extends VerifyRequestUpdateState {
  String message;

  VerifyRequestUpdateErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
