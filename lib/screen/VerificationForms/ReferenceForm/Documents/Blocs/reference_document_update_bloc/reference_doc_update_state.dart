import 'package:equatable/equatable.dart';

class ReferenceDocUpdateState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ReferenceDocUpdateInitialState extends ReferenceDocUpdateState {}

class ReferenceDocUpdateLoadingState extends ReferenceDocUpdateState {}

class ReferenceDocUpdateSuccessState extends ReferenceDocUpdateState {
  //final String message;
  final Map<String, dynamic> data;

  ReferenceDocUpdateSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class ReferenceDocUpdateErrorState extends ReferenceDocUpdateState {
  String message;

  ReferenceDocUpdateErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
