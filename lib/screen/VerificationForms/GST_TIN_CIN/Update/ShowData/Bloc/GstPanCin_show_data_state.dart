import 'package:equatable/equatable.dart';

import '../Model/GstPanCin_show_data_model.dart';

class GstPanCinShowDataState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GstPanCinShowDataInitialState extends GstPanCinShowDataState {}

class GstPanCinShowDataLoadingState extends GstPanCinShowDataState {}

class GstPanCinShowDataSuccessState extends GstPanCinShowDataState {
  final GstPanCinShowDataModel gstPanCinShowDataModel;

  GstPanCinShowDataSuccessState(this.gstPanCinShowDataModel);

  @override
  List<Object?> get props => [gstPanCinShowDataModel];
}

class GstPanCinShowDataErrorState extends GstPanCinShowDataState {
  String message;

  GstPanCinShowDataErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
