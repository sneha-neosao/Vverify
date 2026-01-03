import 'package:equatable/equatable.dart';

class UploadDocumentMumbaiState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UploadDocumentMumbaiInitialState extends UploadDocumentMumbaiState {}

class UploadDocumentMumbaiLoadingState extends UploadDocumentMumbaiState {}

class UploadDocumentMumbaiSuccessState extends UploadDocumentMumbaiState {
  final Map<String,dynamic> data;

  UploadDocumentMumbaiSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class UploadDocumentMumbaiErrorState extends UploadDocumentMumbaiState {
  String message;

  UploadDocumentMumbaiErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
