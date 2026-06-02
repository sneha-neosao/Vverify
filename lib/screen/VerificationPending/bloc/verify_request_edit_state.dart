import 'package:equatable/equatable.dart';

class VerifyRequestEditState extends Equatable {
  @override
  List<Object?> get props => [];
}

class VerifyRequestEditInitialState extends VerifyRequestEditState {}

class VerifyRequestEditLoadingState extends VerifyRequestEditState {}

class VerifyRequestEditSuccessState extends VerifyRequestEditState {
  final Map<String, dynamic> data;

  VerifyRequestEditSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class VerifyRequestEditErrorState extends VerifyRequestEditState {
  String message;

  VerifyRequestEditErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
