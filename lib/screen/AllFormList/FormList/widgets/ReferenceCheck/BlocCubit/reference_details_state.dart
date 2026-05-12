import '../Model/reference_check_details_model.dart';

abstract class ReferenceDetailsState {}

class ReferenceDetailsInitial extends ReferenceDetailsState {}

class ReferenceDetailsLoading extends ReferenceDetailsState {}

class ReferenceDetailsSuccess extends ReferenceDetailsState {
  final ReferenceCheckDetailsData data;
  ReferenceDetailsSuccess(this.data);
}

class ReferenceDetailsError extends ReferenceDetailsState {
  final String error;
  ReferenceDetailsError(this.error);
}
