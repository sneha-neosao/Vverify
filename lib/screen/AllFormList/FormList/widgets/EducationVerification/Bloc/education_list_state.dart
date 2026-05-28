import 'package:equatable/equatable.dart';
import 'package:v_verify/screen/AllFormList/FormList/widgets/EducationVerification/Model/education_list_model.dart';

class EducationDataListState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EducationDataListInitialState extends EducationDataListState {}

class EducationDataListLoadingState extends EducationDataListState {}

class EducationDataListEmptyState extends EducationDataListState {}

class EducationDataListSuccessState extends EducationDataListState {
  final EducationListModel educationListDataModel;

  EducationDataListSuccessState(this.educationListDataModel);

  @override
  List<Object?> get props => [educationListDataModel];
}

class EducationDataListErrorState extends EducationDataListState {
  final String message;

  EducationDataListErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
