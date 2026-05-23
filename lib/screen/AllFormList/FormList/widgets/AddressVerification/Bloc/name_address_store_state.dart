import 'package:equatable/equatable.dart';

abstract class NameAddressStoreState extends Equatable {
  const NameAddressStoreState();

  @override
  List<Object?> get props => [];
}

class NameAddressStoreInitial extends NameAddressStoreState {}

class NameAddressStoreLoading extends NameAddressStoreState {}

class NameAddressStoreSuccess extends NameAddressStoreState {
  final Map<String, dynamic> responseData;

  const NameAddressStoreSuccess(this.responseData);

  @override
  List<Object?> get props => [responseData];
}

class NameAddressStoreFailure extends NameAddressStoreState {
  final String errorMessage;

  const NameAddressStoreFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
