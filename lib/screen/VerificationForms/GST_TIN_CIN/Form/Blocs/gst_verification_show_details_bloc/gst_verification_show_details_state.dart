import 'package:equatable/equatable.dart';

import '../../Models/gst_verification_show_details_model.dart';

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
