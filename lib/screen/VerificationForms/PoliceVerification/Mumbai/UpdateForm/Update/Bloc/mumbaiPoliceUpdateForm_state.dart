import 'package:equatable/equatable.dart';
import 'package:v_verify/screen/VerificationForms/VerifyDeatils/Model/verify_details_model.dart';

class MumbaiPoliceUpdateFormState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MumbaiPoliceUpdateFormInitialState extends MumbaiPoliceUpdateFormState {}

class MumbaiPoliceUpdateFormLoadingState extends MumbaiPoliceUpdateFormState {}

class MumbaiPoliceUpdateFormSuccessState extends MumbaiPoliceUpdateFormState {
  final Map<String,dynamic> data;

  MumbaiPoliceUpdateFormSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class MumbaiPoliceUpdateFormErrorState extends MumbaiPoliceUpdateFormState {
  String message;

  MumbaiPoliceUpdateFormErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
