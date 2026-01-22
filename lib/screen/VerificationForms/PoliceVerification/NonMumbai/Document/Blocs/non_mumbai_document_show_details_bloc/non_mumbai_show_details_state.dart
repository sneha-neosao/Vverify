import 'package:equatable/equatable.dart';

import '../../Models/non_mumbai_show_details_model.dart';

class NonMumbaiDocShowDataState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NonMumbaiDocShowDataInitialState extends NonMumbaiDocShowDataState {}

class NonMumbaiDocShowDataLoadingState extends NonMumbaiDocShowDataState {}

class NonMumbaiDocShowDataSuccessState extends NonMumbaiDocShowDataState {
  final NonMumbaiDocShowDataModel nonMumbaiDocShowDataModel;

  NonMumbaiDocShowDataSuccessState(this.nonMumbaiDocShowDataModel);

  @override
  List<Object?> get props => [nonMumbaiDocShowDataModel];
}

class NonMumbaiDocShowDataErrorState extends NonMumbaiDocShowDataState {
  String message;

  NonMumbaiDocShowDataErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
