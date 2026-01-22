import 'package:equatable/equatable.dart';

class MumbaiDocUpdateState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MumbaiDocUpdateInitialState extends MumbaiDocUpdateState {}

class MumbaiDocUpdateLoadingState extends MumbaiDocUpdateState {}

class MumbaiDocUpdateSuccessState extends MumbaiDocUpdateState {
  final Map<String,dynamic> data;

  MumbaiDocUpdateSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class MumbaiDocUpdateErrorState extends MumbaiDocUpdateState {
  String message;

  MumbaiDocUpdateErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
