import 'package:equatable/equatable.dart';

class DrivingDocUpdateState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DrivingDocUpdateInitialState extends DrivingDocUpdateState {}

class DrivingDocUpdateLoadingState extends DrivingDocUpdateState {}

class DrivingDocUpdateSuccessState extends DrivingDocUpdateState {
  final Map<String, dynamic> data;

  DrivingDocUpdateSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class DrivingDocUpdateErrorState extends DrivingDocUpdateState {
  String message;

  DrivingDocUpdateErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
