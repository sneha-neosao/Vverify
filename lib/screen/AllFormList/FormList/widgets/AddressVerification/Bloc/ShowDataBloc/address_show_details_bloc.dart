import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../apiServices/api_services.dart';
import '../../../../../../VerificationForms/AddressVerificationForm/Form/Models/address_show_details_model.dart';
import 'address_show_details_state.dart';

class NameAddressShowDataCubit extends Cubit<NameAddressShowDataState> {
  ApiService _apiService;

  NameAddressShowDataCubit(this._apiService)
      : super(NameAddressShowDataSInitialState());

  void nameAddressShowData({
    required String token,
    required String uid,
  }) async {
    emit(NameAddressShowDataSLoadingState());
    try {
      final response = await _apiService.nameAddressShowData(
        token: token,
        uid: uid,
      );

      if (response.data != null && response.data.containsKey("status")) {
        NameAddressShowDataModel nameAddressShowDataModel =
            NameAddressShowDataModel.fromJson(response.data);
        if (response.data["status"] == 200) {
          emit(NameAddressShowDataSSuccessState(nameAddressShowDataModel));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(NameAddressShowDataSErrorState(errorMessage));
        } else {
          emit(NameAddressShowDataSErrorState(
              '${response.data["status"]} \n ${response.data["message"]}'));
        }
      } else {
        emit(NameAddressShowDataSErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(NameAddressShowDataSErrorState('An error occurred:$e'));
    }
  }
}
