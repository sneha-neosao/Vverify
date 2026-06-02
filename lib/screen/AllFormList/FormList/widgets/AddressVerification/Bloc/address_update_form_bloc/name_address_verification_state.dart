import 'package:equatable/equatable.dart';

class NameAddressVerificationUpdateState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NameAddressVerificationUpdateInitialState
    extends NameAddressVerificationUpdateState {}

class NameAddressVerificationUpdateLoadingState
    extends NameAddressVerificationUpdateState {}

class NameAddressVerificationUpdateSuccessState
    extends NameAddressVerificationUpdateState {
  final Map<String, dynamic> data;

  NameAddressVerificationUpdateSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class NameAddressVerificationUpdateErrorState
    extends NameAddressVerificationUpdateState {
  String message;

  NameAddressVerificationUpdateErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
