import 'package:equatable/equatable.dart';
import 'package:v_verify/screen/VerificationForms/VerifyDeatils/Model/verify_details_model.dart';

class VerifyRequestReportState extends Equatable {
  @override
  List<Object?> get props => [];
}

class VerifyRequestReportInitialState extends VerifyRequestReportState {}

class VerifyRequestReportLoadingState extends VerifyRequestReportState {}

class VerifyRequestReportDownloadedState extends VerifyRequestReportState {
  final String filePath;
  VerifyRequestReportDownloadedState(this.filePath);

  @override
  List<Object?> get props => [filePath];
}

class VerifyRequestReportErrorState extends VerifyRequestReportState {
  String message;

  VerifyRequestReportErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
