import '../Model/pan_verification_model.dart';

abstract class PanVerificationState {}

class PanVerificationInitial extends PanVerificationState {}

class PanVerificationLoading extends PanVerificationState {}

class PanVerificationSuccess extends PanVerificationState {
  final PanVerificationSubmitModel model;
  PanVerificationSuccess(this.model);
}

class PanShowLoading extends PanVerificationState {}

class PanShowSuccess extends PanVerificationState {
  final ShowData data;
  PanShowSuccess(this.data);
}

class PanVerificationFailure extends PanVerificationState {
  final String error;
  PanVerificationFailure(this.error);
}
