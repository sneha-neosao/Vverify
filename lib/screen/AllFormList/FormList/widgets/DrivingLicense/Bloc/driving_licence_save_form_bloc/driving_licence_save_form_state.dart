import 'package:equatable/equatable.dart';
import '../../Models/driving_licence_save_model.dart';

class DrivingLicenceState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DrivingLicenceInitialState extends DrivingLicenceState {}

class DrivingLicenceLoadingState extends DrivingLicenceState {}

class DrivingLicenceSuccessState extends DrivingLicenceState {
  final DrivingLicenceSaveModel data;

  DrivingLicenceSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class DrivingLicenceErrorState extends DrivingLicenceState {
  String message;

  DrivingLicenceErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
