abstract class GstVerificationState {}

class GstVerificationInitialState extends GstVerificationState {}

class GstVerificationLoadingState extends GstVerificationState {}

class GstVerificationSuccessState extends GstVerificationState {
  final Map<String, dynamic> responseData;
  final String uid;

  GstVerificationSuccessState({required this.responseData, required this.uid});
}

class GstVerificationFailureState extends GstVerificationState {
  final String errorMessage;

  GstVerificationFailureState(this.errorMessage);
}
