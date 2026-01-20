import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_verify/apiServices/api_services.dart';

import '../../Models/Reference_update_form_model.dart';
import 'Reference_update_form_state.dart';

class ReferenceUpdateFormCubit extends Cubit<ReferenceUpdateState> {
  ApiService _apiService;

  ReferenceUpdateFormCubit(this._apiService)
      : super(ReferenceUpdateInitialState());

  void referenceUpdateForm(
      {required String token,
      required String customer_id,
      required ReferenceUpdateModel referenceUpdateModel}) async {
    emit(ReferenceUpdateLoadingState());
    try {
      final response = await _apiService.ReferenceVerificationUpdate(
        customer_id: customer_id,
        token: token,
        referenceUpdateModel: referenceUpdateModel,
      );
      if (response.data != null && response.data.containsKey("status")) {
        if (response.data["status"] == 200) {
          emit(ReferenceUpdateSuccessState(response.data));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(ReferenceUpdateErrorState(errorMessage));
        } else {
          emit(ReferenceUpdateErrorState('${response.data["status"]}'));
        }
      } else {
        emit(ReferenceUpdateErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(ReferenceUpdateErrorState('An error occurred:$e'));
    }
  }
}
