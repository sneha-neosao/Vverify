import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_verify/screen/AllFormList/FormList/widgets/AddressVerification/Bloc/address_list_state.dart';
import 'package:v_verify/screen/AllFormList/FormList/widgets/AddressVerification/Bloc/Models/address_list_model.dart';
import '../../../../../../apiServices/api_services.dart';

class AddressListCubit extends Cubit<AddressDataListState> {
  ApiService _apiService;

  AddressListCubit(this._apiService) : super(AddressDataListInitialState());

  void addressList({
    required String token,
    required int requestId,
    required int serviceRequestId,
  }) async {
    emit(AddressDataListLoadingState());
    try {
      final response = await _apiService.addressList(
        token: token,
        request_id: requestId,
        service_request_id: serviceRequestId,
      );
      if (response.data != null && response.data.containsKey("status")) {
        AddressListModel addressListDataModel =
            AddressListModel.fromJson(response.data);
        if (response.data["status"] == 200) {
          emit(AddressDataListSuccessState(addressListDataModel));
        } else if (response.data["status"] == 300) {
          emit(AddressDataListEmptyState());
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(AddressDataListErrorState(errorMessage));
        } else {
          emit(AddressDataListErrorState('${response.data["message"]}'));
        }
      } else {
        emit(AddressDataListErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(AddressDataListErrorState('An error occurred:$e'));
    }
  }
}
