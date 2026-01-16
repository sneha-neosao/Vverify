import 'package:equatable/equatable.dart';

class PanVerificationSaveState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PanVerificationSaveInitialState
    extends PanVerificationSaveState {}

class PanVerificationSaveLoadingState
    extends PanVerificationSaveState {}

class PanVerificationSaveSuccessState extends PanVerificationSaveState {
  final Map<String,dynamic> data;

  PanVerificationSaveSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class PanVerificationSaveErrorState extends PanVerificationSaveState {
  String message;

  PanVerificationSaveErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
