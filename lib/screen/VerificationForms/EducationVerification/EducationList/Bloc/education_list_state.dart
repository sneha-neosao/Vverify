import 'package:equatable/equatable.dart';

import '../../../EmploymentForm/Update/showData/Model/employ_show_data_model.dart';
import '../Model/education_list_model.dart';

class EducationListState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EducationListInitialState extends EducationListState {}

class EducationListLoadingState extends EducationListState {}

class EducationListEmptyState extends EducationListState {}

class EducationListSuccessState extends EducationListState {
  final EducationDocListModel educationListModel;

  EducationListSuccessState(this.educationListModel);

  @override
  List<Object?> get props => [educationListModel];
}

class EducationListErrorState extends EducationListState {
  String message;

  EducationListErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
