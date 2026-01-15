import 'package:equatable/equatable.dart';
import 'package:v_verify/screen/VerificationForms/EducationVerification/Documents/Models/education_document_model.dart';
import 'package:v_verify/screen/VerificationForms/EmploymentVerification/Documents/Models/employment_document_model.dart';

abstract class EmploymentDocumentListState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EmploymentDocumentListInitialState extends EmploymentDocumentListState {}

class EmploymentDocumentListLoadingState extends EmploymentDocumentListState {}

class EmploymentDocumentListEmptyState extends EmploymentDocumentListState {}

class EmploymentDocumentListSuccessState extends EmploymentDocumentListState {
  final EmploymentDocumentsModel educationDocuments;

  EmploymentDocumentListSuccessState(this.educationDocuments);

  @override
  List<Object?> get props => [educationDocuments];
}

class EmploymentDocumentListErrorState extends EmploymentDocumentListState {
  final String message;

  EmploymentDocumentListErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
