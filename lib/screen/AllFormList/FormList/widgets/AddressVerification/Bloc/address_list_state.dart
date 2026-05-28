import 'package:equatable/equatable.dart';
import 'package:v_verify/screen/AllFormList/FormList/widgets/AddressVerification/Bloc/Models/address_list_model.dart';

class AddressDataListState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddressDataListInitialState extends AddressDataListState {}

class AddressDataListLoadingState extends AddressDataListState {}

class AddressDataListEmptyState extends AddressDataListState {}

class AddressDataListSuccessState extends AddressDataListState {
  final AddressListModel addressListDataModel;

  AddressDataListSuccessState(this.addressListDataModel);

  @override
  List<Object?> get props => [addressListDataModel];
}

class AddressDataListErrorState extends AddressDataListState {
  String message;

  AddressDataListErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
