import 'package:equatable/equatable.dart';
import 'package:v_verify/screen/Home%20screen/model/home_Screen_model.dart';

class UploadDocumentNonMumbaiState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UploadDocumentNonMumbaiInitialState extends UploadDocumentNonMumbaiState {}

class UploadDocumentNonMumbaiLoadingState extends UploadDocumentNonMumbaiState {}

class UploadDocumentNonMumbaiSuccessState extends UploadDocumentNonMumbaiState {
  final Map<String,dynamic> data;

  UploadDocumentNonMumbaiSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class UploadDocumentNonMumbaiErrorState extends UploadDocumentNonMumbaiState {
  String message;

  UploadDocumentNonMumbaiErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
