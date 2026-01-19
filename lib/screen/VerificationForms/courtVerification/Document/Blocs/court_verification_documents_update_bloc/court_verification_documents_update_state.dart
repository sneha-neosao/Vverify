import 'package:equatable/equatable.dart';

class CourtDocUpdateState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CourtDocUpdateInitialState extends CourtDocUpdateState {}

class CourtDocUpdateLoadingState extends CourtDocUpdateState {}

class CourtDocUpdateSuccessState extends CourtDocUpdateState {
  final Map<String, dynamic> data;

  CourtDocUpdateSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class CourtDocUpdateErrorState extends CourtDocUpdateState {
  String message;

  CourtDocUpdateErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
