import 'package:equatable/equatable.dart';
import 'package:v_verify/screen/VerificationForms/EducationVerification/EducationDocList/model/education_document_model.dart';

abstract class EducationDocumentListState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EducationDocumentListInitialState extends EducationDocumentListState {}

class EducationDocumentListLoadingState extends EducationDocumentListState {}

class EducationDocumentListEmptyState extends EducationDocumentListState {}

class EducationDocumentListSuccessState extends EducationDocumentListState {
  final EducationDocumentsModel educationDocuments;

  EducationDocumentListSuccessState(this.educationDocuments);

  @override
  List<Object?> get props => [educationDocuments];
}

class EducationDocumentListErrorState extends EducationDocumentListState {
  final String message;

  EducationDocumentListErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
