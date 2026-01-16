import 'package:equatable/equatable.dart';
import 'package:v_verify/screen/VerificationForms/AddressVerificationForm/Documents/Models/address_document_model.dart';
import 'package:v_verify/screen/VerificationForms/EducationVerification/Documents/Models/education_document_model.dart';

abstract class AddressDocumentListState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddressDocumentListInitialState extends AddressDocumentListState {}

class AddressDocumentListLoadingState extends AddressDocumentListState {}

class AddressDocumentListEmptyState extends AddressDocumentListState {}

class AddressDocumentListSuccessState extends AddressDocumentListState {
  final AddressDocumentsModel addressDocuments;

  AddressDocumentListSuccessState(this.addressDocuments);

  @override
  List<Object?> get props => [addressDocuments];
}

class AddressDocumentListErrorState extends AddressDocumentListState {
  final String message;

  AddressDocumentListErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
