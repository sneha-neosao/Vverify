import 'package:equatable/equatable.dart';

class CourtUpdateState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CourtUpdateInitialState
    extends CourtUpdateState {}

class CourtUpdateLoadingState
    extends CourtUpdateState {}

class CourtUpdateSuccessState extends CourtUpdateState {
  final Map<String,dynamic> data;

  CourtUpdateSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class CourtUpdateErrorState extends CourtUpdateState {
  String message;

  CourtUpdateErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
