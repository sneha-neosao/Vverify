import 'package:equatable/equatable.dart';
import '../driving_licence_show_data_model.dart';

class DrivingLicenceShowDataState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DrivingLicenceShowDataInitialState extends DrivingLicenceShowDataState {}

class DrivingLicenceShowDataLoadingState extends DrivingLicenceShowDataState {}

class DrivingLicenceShowDataSuccessState extends DrivingLicenceShowDataState {
  final DrivingLicenceShowDataModel drivingLicenceShowDataModel;

  DrivingLicenceShowDataSuccessState(this.drivingLicenceShowDataModel);

  @override
  List<Object?> get props => [drivingLicenceShowDataModel];
}

class DrivingLicenceShowDataErrorState extends DrivingLicenceShowDataState {
  String message;

  DrivingLicenceShowDataErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
