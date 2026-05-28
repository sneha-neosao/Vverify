abstract class GstVerificationShowState {}

class GstVerificationShowInitialState extends GstVerificationShowState {}

class GstVerificationShowLoadingState extends GstVerificationShowState {}

class GstVerificationShowSuccessState extends GstVerificationShowState {
  final Map<String, dynamic> responseData;

  GstVerificationShowSuccessState(this.responseData);
}

class GstVerificationShowFailureState extends GstVerificationShowState {
  final String errorMessage;

  GstVerificationShowFailureState(this.errorMessage);
}
