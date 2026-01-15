import 'package:equatable/equatable.dart';

class NameAddressDocUploadState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NameAddressDocUploadInitialState
    extends NameAddressDocUploadState {}

class NameAddressDocUploadLoadingState
    extends NameAddressDocUploadState {}

class NameAddressDocUploadSuccessState extends NameAddressDocUploadState {
  final Map<String,dynamic> data;

  NameAddressDocUploadSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class NameAddressDocUploadErrorState extends NameAddressDocUploadState {
  String message;

  NameAddressDocUploadErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
