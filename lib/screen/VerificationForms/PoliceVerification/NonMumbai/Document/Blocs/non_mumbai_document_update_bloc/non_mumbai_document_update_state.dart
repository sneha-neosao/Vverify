import 'package:equatable/equatable.dart';

class UpdateDocumentsNonMumbaiState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UpdateDocumentsNonMumbaiInitialState extends UpdateDocumentsNonMumbaiState {}

class UpdateDocumentsNonMumbaiLoadingState extends UpdateDocumentsNonMumbaiState {}

class UpdateDocumentsNonMumbaiSuccessState extends UpdateDocumentsNonMumbaiState {
  final Map<String,dynamic> data;

  UpdateDocumentsNonMumbaiSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class UpdateDocumentsNonMumbaiErrorState extends UpdateDocumentsNonMumbaiState {
  String message;

  UpdateDocumentsNonMumbaiErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
