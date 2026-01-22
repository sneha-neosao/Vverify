import 'package:equatable/equatable.dart';
import 'package:v_verify/screen/VerificationForms/VerifyDeatils/Model/verify_details_model.dart';

import '../../Models/mumbai_police_show_details_model.dart';

class MumbaiShowDataState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MumbaiShowDataInitialState extends MumbaiShowDataState {}

class MumbaiShowDataLoadingState extends MumbaiShowDataState {}

class MumbaiShowDataSuccessState extends MumbaiShowDataState {
  final MumbaiShowDataModel mumbaiShowDataModel;

  MumbaiShowDataSuccessState(this.mumbaiShowDataModel);

  @override
  List<Object?> get props => [mumbaiShowDataModel];
}

class MumbaiShowDataErrorState extends MumbaiShowDataState {
  String message;

  MumbaiShowDataErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
