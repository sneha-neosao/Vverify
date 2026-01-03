import 'package:equatable/equatable.dart';

class NameAddressDocUpdateState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NameAddressDocUpdateInitialState
    extends NameAddressDocUpdateState {}

class NameAddressDocUpdateLoadingState
    extends NameAddressDocUpdateState {}

class NameAddressDocUpdateSuccessState extends NameAddressDocUpdateState {
  final Map<String,dynamic> data;

  NameAddressDocUpdateSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class NameAddressDocUpdateErrorState extends NameAddressDocUpdateState {
  String message;

  NameAddressDocUpdateErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
