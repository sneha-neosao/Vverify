import 'package:equatable/equatable.dart';

class PanDocUpdateState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PanDocUpdateInitialState extends PanDocUpdateState {}

class PanDocUpdateLoadingState extends PanDocUpdateState {}

class PanDocUpdateSuccessState extends PanDocUpdateState {
  final Map<String,dynamic> data;

  PanDocUpdateSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class PanDocUpdateErrorState extends PanDocUpdateState {
  String message;

  PanDocUpdateErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
