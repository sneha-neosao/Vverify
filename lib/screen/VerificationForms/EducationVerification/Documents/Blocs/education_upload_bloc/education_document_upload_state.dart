import 'package:equatable/equatable.dart';

class EducationDocUploadStateNew extends Equatable {
  @override
  List<Object?> get props => [];
}

class EducationDocUploadInitialStateNew extends EducationDocUploadStateNew {}

class EducationDocUploadLoadingStateNew extends EducationDocUploadStateNew {}

class EducationDocUploadSuccessStateNew extends EducationDocUploadStateNew {
  final Map<String,dynamic> data;

  EducationDocUploadSuccessStateNew(this.data);

  @override
  List<Object?> get props => [data];
}

class EducationDocUploadErrorStateNew extends EducationDocUploadStateNew {
  String message;

  EducationDocUploadErrorStateNew(this.message);

  @override
  List<Object?> get props => [message];
}
