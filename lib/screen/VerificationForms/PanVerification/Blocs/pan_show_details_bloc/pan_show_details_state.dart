import 'package:equatable/equatable.dart';

import '../../Models/pan_show_details_model.dart';

class PanVerificationShowState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PanVerificationShowInitialState
    extends PanVerificationShowState {}

class PanVerificationShowLoadingState
    extends PanVerificationShowState {}

class PanVerificationShowSuccessState extends PanVerificationShowState {
  final PanVerificationShowModel panVerificationShowModel;

  PanVerificationShowSuccessState(this.panVerificationShowModel);

  @override
  List<Object?> get props => [panVerificationShowModel];
}

class PanVerificationShowErrorState extends PanVerificationShowState {
  String message;

  PanVerificationShowErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
