import 'package:equatable/equatable.dart';
import 'package:v_verify/screen/VerificationForms/VerifyDeatils/Model/verify_details_model.dart';

import '../../../UpdateDocument/showdata/model/non_mumbai_show_data_model.dart';
import '../Model/Non_MumbaiShowData_model.dart';

class NonMumbaiShowDataState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NonMumbaiShowDataInitialState extends NonMumbaiShowDataState {}

class NonMumbaiShowDataLoadingState extends NonMumbaiShowDataState {}

class NonMumbaiShowDataSuccessState extends NonMumbaiShowDataState {
  final NonMumbaiShowDataModel nonMumbaiShowDataModel;

  NonMumbaiShowDataSuccessState(this.nonMumbaiShowDataModel);

  @override
  List<Object?> get props => [nonMumbaiShowDataModel];
}

class NonMumbaiShowDataErrorState extends NonMumbaiShowDataState {
  String message;

  NonMumbaiShowDataErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
