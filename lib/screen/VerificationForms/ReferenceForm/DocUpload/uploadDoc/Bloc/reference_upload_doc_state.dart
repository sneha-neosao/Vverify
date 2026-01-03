import 'package:equatable/equatable.dart';

class ReferenceUploadDocState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ReferenceUploadDocInitialState extends ReferenceUploadDocState {}

class ReferenceUploadDocLoadingState extends ReferenceUploadDocState {}

class ReferenceUploadDocSuccessState extends ReferenceUploadDocState {
  //final String message;
  final Map<String,dynamic> data;

  ReferenceUploadDocSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class ReferenceUploadDocErrorState extends ReferenceUploadDocState {
  String message;

  ReferenceUploadDocErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
