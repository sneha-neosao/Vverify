import 'package:equatable/equatable.dart';

import '../Models/employment_list_model.dart';

class EmployDataListState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EmployDataListInitialState extends EmployDataListState {}

class EmployDataListLoadingState extends EmployDataListState {}

class EmployDataListEmptyState extends EmployDataListState {}

class EmployDataListSuccessState extends EmployDataListState {
  final EmployListDataModel employListDataModel;

  EmployDataListSuccessState(this.employListDataModel);

  @override
  List<Object?> get props => [employListDataModel];
}

class EmployDataListErrorState extends EmployDataListState {
  String message;

  EmployDataListErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
