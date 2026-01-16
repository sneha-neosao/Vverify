import 'package:equatable/equatable.dart';

class AddressDocUploadStateNew extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddressDocUploadInitialStateNew extends AddressDocUploadStateNew {}

class AddressDocUploadLoadingStateNew extends AddressDocUploadStateNew {}

class AddressDocUploadSuccessStateNew extends AddressDocUploadStateNew {
  final Map<String,dynamic> data;

  AddressDocUploadSuccessStateNew(this.data);

  @override
  List<Object?> get props => [data];
}

class AddressDocUploadErrorStateNew extends AddressDocUploadStateNew {
  String message;

  AddressDocUploadErrorStateNew(this.message);

  @override
  List<Object?> get props => [message];
}
