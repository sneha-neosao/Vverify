import 'package:equatable/equatable.dart';

class CourtDocUploadState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CourtDocUploadInitialState
    extends CourtDocUploadState {}

class CourtDocUploadLoadingState
    extends CourtDocUploadState {}

class CourtDocUploadSuccessState extends CourtDocUploadState {
  final Map<String,dynamic> data;

  CourtDocUploadSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class CourtDocUploadErrorState extends CourtDocUploadState {
  String message;

  CourtDocUploadErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
