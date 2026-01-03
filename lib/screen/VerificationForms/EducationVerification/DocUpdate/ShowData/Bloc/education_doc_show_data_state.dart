import 'package:equatable/equatable.dart';

import '../Model/education_show_doc_model.dart';

class EducationDocShowDataState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EducationDocShowDataInitialState extends EducationDocShowDataState {}

class EducationDocShowDataLoadingState extends EducationDocShowDataState {}

class EducationDocShowDataSuccessState extends EducationDocShowDataState {
  final EducationShowDocModel educationShowDocModel;

  EducationDocShowDataSuccessState(this.educationShowDocModel);

  @override
  List<Object?> get props => [educationShowDocModel];
}

class EducationDocShowDataErrorState extends EducationDocShowDataState {
  String message;

  EducationDocShowDataErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
