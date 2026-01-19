import 'package:equatable/equatable.dart';

class CourtVerificationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CourtVerificationInitialState
    extends CourtVerificationState {}

class CourtVerificationLoadingState
    extends CourtVerificationState {}

class CourtVerificationSuccessState extends CourtVerificationState {
  final Map<String,dynamic> data;

  CourtVerificationSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class CourtVerificationErrorState extends CourtVerificationState {
  String message;

  CourtVerificationErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
