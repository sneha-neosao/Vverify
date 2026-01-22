import 'package:equatable/equatable.dart';
import 'package:v_verify/screen/VerificationForms/VerifyDeatils/Model/verify_details_model.dart';

class NonMumbaiPoliceVerificationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NonMumbaiPoliceVerificationInitialState extends NonMumbaiPoliceVerificationState {}

class NonMumbaiPoliceVerificationLoadingState extends NonMumbaiPoliceVerificationState {}

class NonMumbaiPoliceVerificationSuccessState extends NonMumbaiPoliceVerificationState {
  final Map<String,dynamic> data;

  NonMumbaiPoliceVerificationSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class NonMumbaiPoliceVerificationErrorState extends NonMumbaiPoliceVerificationState {
  String message;

  NonMumbaiPoliceVerificationErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
