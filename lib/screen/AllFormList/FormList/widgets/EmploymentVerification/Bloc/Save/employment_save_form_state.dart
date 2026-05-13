import 'package:equatable/equatable.dart';

class EmploymentSaveFormState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EmploymentSaveFormInitialState extends EmploymentSaveFormState {}

class EmploymentSaveFormLoadingState extends EmploymentSaveFormState {}

class EmploymentSaveFormSuccessState extends EmploymentSaveFormState {
  final Map<String, dynamic> data;

  EmploymentSaveFormSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class EmploymentSaveFormErrorState extends EmploymentSaveFormState {
  String message;

  EmploymentSaveFormErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
