import 'package:equatable/equatable.dart';

class DrivingLicenceUpdateState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DrivingLicenceUpdateInitialState extends DrivingLicenceUpdateState {}

class DrivingLicenceUpdateLoadingState extends DrivingLicenceUpdateState {}

class DrivingLicenceUpdateSuccessState extends DrivingLicenceUpdateState {
  final Map<String,dynamic> data;

  DrivingLicenceUpdateSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class DrivingLicenceUpdateErrorState extends DrivingLicenceUpdateState {
  String message;

  DrivingLicenceUpdateErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
