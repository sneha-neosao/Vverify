import '../Model/bank_account_model.dart';

abstract class BankDetailsState {}

class BankDetailsInitial extends BankDetailsState {}

class BankDetailsLoading extends BankDetailsState {}

class BankDetailsSuccess extends BankDetailsState {
  final Data data;
  BankDetailsSuccess(this.data);
}

class BankDetailsError extends BankDetailsState {
  final String error;
  BankDetailsError(this.error);
}
