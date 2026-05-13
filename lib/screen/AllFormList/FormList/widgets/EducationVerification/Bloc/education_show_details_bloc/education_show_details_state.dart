import 'package:equatable/equatable.dart';

import '../../Model/education_show_details_model.dart';

class EducationShowDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EducationShowDetailsInitialState extends EducationShowDetailsState {}

class EducationShowDetailsLoadingState extends EducationShowDetailsState {}

class EducationShowDetailsSuccessState extends EducationShowDetailsState {
  final EducationDataDetailsModel educationDataDetailsModel;

  EducationShowDetailsSuccessState(this.educationDataDetailsModel);

  @override
  List<Object?> get props => [educationDataDetailsModel];
}

class EducationShowDetailsErrorState extends EducationShowDetailsState {
  String message;

  EducationShowDetailsErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
