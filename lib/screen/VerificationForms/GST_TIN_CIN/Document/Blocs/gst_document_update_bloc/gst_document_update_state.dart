import 'package:equatable/equatable.dart';

class GstPanCinDocUpdateState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GstPanCinDocUpdateInitialState extends GstPanCinDocUpdateState {}

class GstPanCinDocUpdateLoadingState extends GstPanCinDocUpdateState {}

class GstPanCinDocUpdateSuccessState extends GstPanCinDocUpdateState {
  final Map<String,dynamic> data;

  GstPanCinDocUpdateSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class GstPanCinDocUpdateErrorState extends GstPanCinDocUpdateState {
  String message;

  GstPanCinDocUpdateErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
