import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_verify/apiServices/api_services.dart';

import '../Model/mumbaiPoliceUpdateForm_model.dart';
import 'mumbaiPoliceUpdateForm_state.dart';

class MumbaiPoliceUpdateFromCubit extends Cubit<MumbaiPoliceUpdateFormState> {
  ApiService _apiService;

  MumbaiPoliceUpdateFromCubit(this._apiService)
      : super(MumbaiPoliceUpdateFormInitialState());

  void mumbaiPoliceUpdateForm(
      {
        required String token,
        required String customer_id,
      required MumbaiUpdateModel mumbaiUpdateModel}) async {
    emit(MumbaiPoliceUpdateFormLoadingState());
    try {
      final response = await _apiService.tenantMumbaiFormUpdate(
        token: token,
        customer_id: customer_id,
        mumbaiUpdateModel: mumbaiUpdateModel,
      );
      if (response.data != null && response.data.containsKey("status")) {
        if (response.data["status"] == 200) {
          emit(MumbaiPoliceUpdateFormSuccessState(response.data));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(MumbaiPoliceUpdateFormErrorState(errorMessage));
        } else {
          emit(MumbaiPoliceUpdateFormErrorState('${response.data["message"]}'));
        }
      } else {
        emit(MumbaiPoliceUpdateFormErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(MumbaiPoliceUpdateFormErrorState('An error occurred:$e'));
    }
  }
}
