import 'package:equatable/equatable.dart';

class EmploymentUploadState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EmploymentUploadInitialState extends EmploymentUploadState {}

class EmploymentUploadLoadingState extends EmploymentUploadState {}

class EmploymentUploadSuccessState extends EmploymentUploadState {
  final Map<String,dynamic> data;

  EmploymentUploadSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class EmploymentUploadErrorState extends EmploymentUploadState {
  String message;

  EmploymentUploadErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
