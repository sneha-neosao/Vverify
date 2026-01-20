import 'package:equatable/equatable.dart';
import 'package:v_verify/screen/VerificationForms/ReferenceForm/Form/Models/reference_show_details_model.dart';
import 'package:v_verify/screen/VerificationForms/VerifyDeatils/Model/verify_details_model.dart';

class ReferenceCheckDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ReferenceCheckDetailsInitialState extends ReferenceCheckDetailsState {}

class ReferenceCheckDetailsLoadingState extends ReferenceCheckDetailsState {}

class ReferenceCheckDetailsSuccessState extends ReferenceCheckDetailsState {
  final ReferenceCheckDetailsModel referenceCheckDetailsModel;

  ReferenceCheckDetailsSuccessState(this.referenceCheckDetailsModel);

  @override
  List<Object?> get props => [referenceCheckDetailsModel];
}

class ReferenceCheckDetailsErrorState extends ReferenceCheckDetailsState {
  String message;

  ReferenceCheckDetailsErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
