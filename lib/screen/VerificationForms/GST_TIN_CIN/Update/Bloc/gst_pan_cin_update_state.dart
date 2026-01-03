import 'package:equatable/equatable.dart';

class GstPanCinUpdateState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GstPanCinUpdateInitialState extends GstPanCinUpdateState {}

class GstPanCinUpdateLoadingState extends GstPanCinUpdateState {}

class GstPanCinUpdateSuccessState extends GstPanCinUpdateState {
  final Map<String,dynamic> data;

  GstPanCinUpdateSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class GstPanCinUpdateErrorState extends GstPanCinUpdateState {
  String message;

  GstPanCinUpdateErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
