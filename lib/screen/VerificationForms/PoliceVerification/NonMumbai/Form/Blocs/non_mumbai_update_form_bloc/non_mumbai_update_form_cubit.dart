import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_verify/apiServices/api_services.dart';

import '../../Models/non_mumbai-police_update_form_model.dart';
import 'non_mumbai_update_form_state.dart';

class NonMumbaiPoliceVerificationCubit
    extends Cubit<NonMumbaiPoliceVerificationState> {
  ApiService _apiService;

  NonMumbaiPoliceVerificationCubit(this._apiService)
      : super(NonMumbaiPoliceVerificationInitialState());

  void nonMumbaiPoliceUpdateForm(
      {
        required String token,
        required String customer_id,
      required NonMumbaiUpdateModel nonMumbaiUpdateModel}) async {
    emit(NonMumbaiPoliceVerificationLoadingState());
    try {
      final response = await _apiService.tenantNonMumbaiFormUpdate(
        token: token,
        customer_id: customer_id,
        nonMumbaiUpdateModel: nonMumbaiUpdateModel,
      );
      if (response.data != null && response.data.containsKey("status")) {
        if (response.data["status"] == 200) {
          emit(NonMumbaiPoliceVerificationSuccessState(response.data));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(NonMumbaiPoliceVerificationErrorState(errorMessage));
        } else {
          emit(NonMumbaiPoliceVerificationErrorState(
              '${response.data["message"]}'));
        }
      } else {
        emit(NonMumbaiPoliceVerificationErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(NonMumbaiPoliceVerificationErrorState('An error occurred:$e'));
    }
  }
}
