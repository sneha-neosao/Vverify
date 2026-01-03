import 'package:equatable/equatable.dart';

class EducationDocUpdateState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EducationDocUpdateInitialState extends EducationDocUpdateState {}

class EducationDocUpdateLoadingState extends EducationDocUpdateState {}

class EducationDocUpdateSuccessState extends EducationDocUpdateState {
  final Map<String,dynamic> data;

  EducationDocUpdateSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class EducationDocUpdateErrorState extends EducationDocUpdateState {
  String message;

  EducationDocUpdateErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
