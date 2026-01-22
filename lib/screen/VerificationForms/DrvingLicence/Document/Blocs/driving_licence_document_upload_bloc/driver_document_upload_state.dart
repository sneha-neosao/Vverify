import 'package:equatable/equatable.dart';

class DriverDocUploadState extends Equatable {
  @override
  List<Object?> get props => [];
}
class DriverDocUploadInitialState extends DriverDocUploadState {}

class DriverDocUploadLoadingState extends DriverDocUploadState {}

class DriverDocUploadSuccessState extends DriverDocUploadState {
  final Map<String,dynamic> data;

  DriverDocUploadSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class DriverDocUploadErrorState extends DriverDocUploadState {
  String message;

  DriverDocUploadErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
