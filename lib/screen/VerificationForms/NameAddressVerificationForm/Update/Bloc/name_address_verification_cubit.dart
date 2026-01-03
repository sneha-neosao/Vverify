import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../apiServices/api_services.dart';
import '../model/name_address_verification_model.dart';
import 'name_address_verification_state.dart';


class NameAddressVerificationUpdateFormCubit
    extends Cubit<NameAddressVerificationUpdateState> {
  ApiService _apiService;

  NameAddressVerificationUpdateFormCubit(this._apiService)
      : super(NameAddressVerificationUpdateInitialState());

  void nameAddressUpdateForm(
      {
        required String token,
        required String customer_id,
      required NameAddressVerificationUpdateModel
          nameAddressVerificationUpdateModel}) async {
    emit(NameAddressVerificationUpdateLoadingState());
    try {
      final response = await _apiService.NameAddressUpdate(
          token: token,
          customer_id: customer_id,
          nameAddressVerificationUpdateModel: nameAddressVerificationUpdateModel);

      if (response.data != null && response.data.containsKey("status")) {
        if (response.data["status"] == 200) {
          emit(NameAddressVerificationUpdateSuccessState(response.data));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(NameAddressVerificationUpdateErrorState(errorMessage));
        } else {
          emit(NameAddressVerificationUpdateErrorState(
              '${response.data["status"]} \n ${response.data["message"]}'));
        }
      } else {
        emit(NameAddressVerificationUpdateErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(NameAddressVerificationUpdateErrorState('An error occurred:$e'));
    }
  }
}
