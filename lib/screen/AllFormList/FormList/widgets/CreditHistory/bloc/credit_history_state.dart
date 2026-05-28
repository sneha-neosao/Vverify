abstract class CreditHistoryState {}

class CreditHistoryInitialState extends CreditHistoryState {}

// Send OTP states
class CreditHistoryOtpLoadingState extends CreditHistoryState {}

class CreditHistoryOtpSuccessState extends CreditHistoryState {
  final String otpRefId;
  final String message;

  CreditHistoryOtpSuccessState({required this.otpRefId, required this.message});
}

class CreditHistoryOtpFailureState extends CreditHistoryState {
  final String errorMessage;

  CreditHistoryOtpFailureState(this.errorMessage);
}

// Store report states
class CreditHistoryStoreLoadingState extends CreditHistoryState {}

class CreditHistoryStoreSuccessState extends CreditHistoryState {
  final Map<String, dynamic> responseData;
  final String uid;

  CreditHistoryStoreSuccessState({required this.responseData, required this.uid});
}

class CreditHistoryStoreFailureState extends CreditHistoryState {
  final String errorMessage;

  CreditHistoryStoreFailureState(this.errorMessage);
}
