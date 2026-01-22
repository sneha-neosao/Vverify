import 'package:equatable/equatable.dart';

class GstPanCinSaveState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GstPanCinSaveInitialState extends GstPanCinSaveState {}

class GstPanCinSaveLoadingState extends GstPanCinSaveState {}

class GstPanCinSaveSuccessState extends GstPanCinSaveState {
  final Map<String,dynamic> data;

  GstPanCinSaveSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class GstPanCinSaveErrorState extends GstPanCinSaveState {
  String message;

  GstPanCinSaveErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
