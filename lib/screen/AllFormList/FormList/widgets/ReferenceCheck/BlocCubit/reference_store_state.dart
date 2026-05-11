import '../Model/verify_request_response_model.dart';

abstract class ReferenceStoreState {}

class ReferenceStoreInitial extends ReferenceStoreState {}

class ReferenceStoreLoading extends ReferenceStoreState {}

class ReferenceStoreSuccess extends ReferenceStoreState {
  final String message;
  ReferenceStoreSuccess(this.message);
}

class ReferenceStoreError extends ReferenceStoreState {
  final String error;
  ReferenceStoreError(this.error);
}

// Separate states for fetching details
class ReferenceDetailsInitial extends ReferenceStoreState {}

class ReferenceDetailsLoading extends ReferenceStoreState {}

class ReferenceDetailsSuccess extends ReferenceStoreState {
  final ReferenceCheckVerification data;
  ReferenceDetailsSuccess(this.data);
}

class ReferenceDetailsError extends ReferenceStoreState {
  final String error;
  ReferenceDetailsError(this.error);
}
