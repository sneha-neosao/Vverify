import 'package:equatable/equatable.dart';

class GstPanCinDocUploadState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GstPanCinDocUploadInitialState extends GstPanCinDocUploadState {}

class GstPanCinDocUploadLoadingState extends GstPanCinDocUploadState {}

class GstPanCinDocUploadSuccessState extends GstPanCinDocUploadState {
  final Map<String,dynamic> data;

  GstPanCinDocUploadSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class GstPanCinDocUploadErrorState extends GstPanCinDocUploadState {
  String message;

  GstPanCinDocUploadErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
