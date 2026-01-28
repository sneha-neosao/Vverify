import 'package:equatable/equatable.dart';

class PanVerificationUpdateState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PanVerificationUpdateInitialState
    extends PanVerificationUpdateState {}

class PanVerificationUpdateLoadingState
    extends PanVerificationUpdateState {}

class PanVerificationUpdateSuccessState extends PanVerificationUpdateState {
  final Map<String,dynamic> data;

  PanVerificationUpdateSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class PanVerificationUpdateErrorState extends PanVerificationUpdateState {
  String message;

  PanVerificationUpdateErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
