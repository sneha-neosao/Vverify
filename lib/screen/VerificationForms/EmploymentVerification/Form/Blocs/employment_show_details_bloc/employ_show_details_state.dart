import 'package:equatable/equatable.dart';

import '../../Models/employment_show_details_model.dart';


class EmployShowDataState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EmployShowDataInitialState extends EmployShowDataState {}

class EmployShowDataLoadingState extends EmployShowDataState {}

class EmployShowDataSuccessState extends EmployShowDataState {
  final EmploymentShowDataModel employmentShowDataModel;

  EmployShowDataSuccessState(this.employmentShowDataModel);

  @override
  List<Object?> get props => [employmentShowDataModel];
}

class EmployShowDataErrorState extends EmployShowDataState {
  String message;

  EmployShowDataErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
