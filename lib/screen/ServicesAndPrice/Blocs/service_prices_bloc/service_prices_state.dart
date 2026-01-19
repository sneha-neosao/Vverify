import 'package:equatable/equatable.dart';

import '../../Models/service_prices_model.dart';

class ServicePriceState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ServicePriceInitialState extends ServicePriceState {}

class ServicePriceLoading extends ServicePriceState {}

class ServicePriceSuccess extends ServicePriceState {
  final ServicePriceModel servicePriceModel;

  ServicePriceSuccess(this.servicePriceModel);

  @override
  List<Object?> get props => [servicePriceModel];
}

class ServicePriceError extends ServicePriceState {
  final String errorMessage;

  ServicePriceError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
