import 'package:equatable/equatable.dart';

class ReferenceVerificationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ReferenceVerificationInitialState extends ReferenceVerificationState {}

class ReferenceVerificationLoadingState extends ReferenceVerificationState {}

class ReferenceVerificationSuccessState extends ReferenceVerificationState {
  //final String message;
  final Map<String,dynamic> data;

  ReferenceVerificationSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class ReferenceVerificationErrorState extends ReferenceVerificationState {
  String message;

  ReferenceVerificationErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
