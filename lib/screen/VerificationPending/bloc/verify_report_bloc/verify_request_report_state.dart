import 'package:equatable/equatable.dart';

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
