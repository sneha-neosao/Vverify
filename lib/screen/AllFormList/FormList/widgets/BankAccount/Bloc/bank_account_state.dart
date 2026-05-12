abstract class BankAccountState {}

class BankAccountInitialState extends BankAccountState {}

class BankAccountLoadingState extends BankAccountState {}

class BankAccountSuccessState extends BankAccountState {
  final Map<String, dynamic> data;
  BankAccountSuccessState(this.data);
}

class BankAccountErrorState extends BankAccountState {
  final String message;
  BankAccountErrorState(this.message);
}
