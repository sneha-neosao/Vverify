import 'package:equatable/equatable.dart';

class EducationUpdateFormState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EducationUpdateFormInitialState extends EducationUpdateFormState {}

class EducationUpdateFormLoadingState extends EducationUpdateFormState {}

class EducationUpdateFormSuccessState extends EducationUpdateFormState {
  final Map<String, dynamic> data;

  EducationUpdateFormSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class EducationUpdateFormErrorState extends EducationUpdateFormState {
  String message;

  EducationUpdateFormErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
