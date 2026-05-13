import 'package:equatable/equatable.dart';

class EmploymentUpdateFormState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EmploymentUpdateFormInitialState extends EmploymentUpdateFormState {}

class EmploymentUpdateFormLoadingState extends EmploymentUpdateFormState {}

class EmploymentUpdateFormSuccessState extends EmploymentUpdateFormState {
  final Map<String, dynamic> data;

  EmploymentUpdateFormSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class EmploymentUpdateFormErrorState extends EmploymentUpdateFormState {
  String message;

  EmploymentUpdateFormErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
