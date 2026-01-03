import 'package:equatable/equatable.dart';

class ReferenceUpdateState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ReferenceUpdateInitialState extends ReferenceUpdateState {}

class ReferenceUpdateLoadingState extends ReferenceUpdateState {}

class ReferenceUpdateSuccessState extends ReferenceUpdateState {
  final Map<String,dynamic> data;

  ReferenceUpdateSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class ReferenceUpdateErrorState extends ReferenceUpdateState {
  String message;

  ReferenceUpdateErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
