import '../model/credit_report_show_model.dart';

abstract class CreditHistoryShowState {}

class CreditHistoryShowInitialState extends CreditHistoryShowState {}

class CreditHistoryShowLoadingState extends CreditHistoryShowState {}

class CreditHistoryShowSuccessState extends CreditHistoryShowState {
  final CreditReportShowModel model;

  CreditHistoryShowSuccessState(this.model);
}

class CreditHistoryShowFailureState extends CreditHistoryShowState {
  final String errorMessage;

  CreditHistoryShowFailureState(this.errorMessage);
}
