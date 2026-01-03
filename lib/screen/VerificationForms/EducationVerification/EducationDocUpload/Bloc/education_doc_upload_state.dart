import 'package:equatable/equatable.dart';

class EducationDocUploadState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EducationDocUploadInitialState extends EducationDocUploadState {}

class EducationDocUploadLoadingState extends EducationDocUploadState {}

class EducationDocUploadSuccessState extends EducationDocUploadState {
  final Map<String,dynamic> data;

  EducationDocUploadSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class EducationDocUploadErrorState extends EducationDocUploadState {
  String message;

  EducationDocUploadErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
