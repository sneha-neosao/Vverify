import 'package:equatable/equatable.dart';

import '../Model/nameAddress_showData_mdoel.dart';

class NameAddressShowDataState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NameAddressShowDataSInitialState
    extends NameAddressShowDataState {}

class NameAddressShowDataSLoadingState
    extends NameAddressShowDataState {}

class NameAddressShowDataSSuccessState extends NameAddressShowDataState {
  final NameAddressShowDataModel nameAddressShowDataModel;

  NameAddressShowDataSSuccessState(this.nameAddressShowDataModel);

  @override
  List<Object?> get props => [nameAddressShowDataModel];
}

class NameAddressShowDataSErrorState extends NameAddressShowDataState {
  String message;

  NameAddressShowDataSErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
