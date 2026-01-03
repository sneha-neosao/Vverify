import 'package:equatable/equatable.dart';

class EducationSaveFormState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EducationSaveFormInitialState extends EducationSaveFormState {}

class EducationSaveFormLoadingState extends EducationSaveFormState {}

class EducationSaveFormSuccessState extends EducationSaveFormState {
  final Map<String,dynamic> data;

  EducationSaveFormSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class EducationSaveFormErrorState extends EducationSaveFormState {
  String message;

  EducationSaveFormErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
