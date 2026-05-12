abstract class ReferenceStoreState {}

class ReferenceStoreInitial extends ReferenceStoreState {}

class ReferenceStoreLoading extends ReferenceStoreState {}

class ReferenceStoreSuccess extends ReferenceStoreState {
  final String message;
  final String? uid;
  ReferenceStoreSuccess(this.message, {this.uid});
}

class ReferenceStoreError extends ReferenceStoreState {
  final String error;
  ReferenceStoreError(this.error);
}
