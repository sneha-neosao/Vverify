import 'package:equatable/equatable.dart';
import '../Model/court_verification_model.dart';

abstract class CourtDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CourtDetailsInitial extends CourtDetailsState {}

class CourtDetailsLoading extends CourtDetailsState {}

class CourtDetailsSuccess extends CourtDetailsState {
  final Data data;
  CourtDetailsSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

class CourtDetailsError extends CourtDetailsState {
  final String error;
  CourtDetailsError(this.error);

  @override
  List<Object?> get props => [error];
}
