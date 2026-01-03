import 'package:equatable/equatable.dart';
import 'package:v_verify/screen/VerificationForms/VerifyDeatils/Model/verify_details_model.dart';

class VerifyDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class VerifyDetailsInitialState extends VerifyDetailsState {}

class VerifyDetailsLoadingState extends VerifyDetailsState {}

class VerifyDetailsSuccessState extends VerifyDetailsState {
  final VerifyDetailsModel verifyDetailsModel;

  VerifyDetailsSuccessState(this.verifyDetailsModel);

  @override
  List<Object?> get props => [verifyDetailsModel];
}

class VerifyDetailsErrorState extends VerifyDetailsState {
  String message;

  VerifyDetailsErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
