import 'package:equatable/equatable.dart';

class EmployDocUpdateState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EmployDocUpdateInitialState extends EmployDocUpdateState {}

class EmployDocUpdateLoadingState extends EmployDocUpdateState {}

class EmployDocUpdateSuccessState extends EmployDocUpdateState {
  final Map<String,dynamic> data;

  EmployDocUpdateSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class EmployDocUpdateErrorState extends EmployDocUpdateState {
  String message;

  EmployDocUpdateErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
