import 'package:equatable/equatable.dart';

import '../Model/show_court_data_model.dart';

class ShowCourtDataState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ShowCourtDataInitialState
    extends ShowCourtDataState {}

class ShowCourtDataLoadingState
    extends ShowCourtDataState {}

class ShowCourtDataSuccessState extends ShowCourtDataState {
  final ShowCourtDataModel showCourtDataModel;

  ShowCourtDataSuccessState(this.showCourtDataModel);

  @override
  List<Object?> get props => [showCourtDataModel];
}

class ShowCourtDataErrorState extends ShowCourtDataState {
  String message;

  ShowCourtDataErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
