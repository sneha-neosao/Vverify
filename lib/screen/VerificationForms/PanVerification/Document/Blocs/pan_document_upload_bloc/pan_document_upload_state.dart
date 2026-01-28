import 'package:equatable/equatable.dart';

class PanDocUploadState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PanDocUploadInitialState extends PanDocUploadState {}

class PanDocUploadLoadingState extends PanDocUploadState {}

class PanDocUploadSuccessState extends PanDocUploadState {
  final Map<String,dynamic> data;

  PanDocUploadSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class PanDocUploadErrorState extends PanDocUploadState {
  String message;

  PanDocUploadErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
