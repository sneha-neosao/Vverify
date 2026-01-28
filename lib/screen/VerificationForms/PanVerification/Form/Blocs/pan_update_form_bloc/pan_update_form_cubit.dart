import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_verify/screen/VerificationForms/PanVerification/Form/Blocs/pan_save_form_bloc/pan_save_form_state.dart';
import 'package:v_verify/screen/VerificationForms/PanVerification/Form/Blocs/pan_update_form_bloc/pan_update_form_state.dart';

import '../../../../../../apiServices/api_services.dart';

class PanVerificationUpdateBloc extends Cubit<PanVerificationUpdateState> {
  ApiService _apiService;

  PanVerificationUpdateBloc(this._apiService)
      : super(PanVerificationUpdateInitialState());

  void panCardNumberUpdate({
    required String token,
    required String serviceRequestId,
    required String requestId,
    required String customer_id,
    required String document_type,
    required String document_number
    // required String panNumber,
  }) async {
    emit(PanVerificationUpdateLoadingState());
    try {
      final response = await _apiService.panNumberUpdate(
        requestId: requestId,
        customer_id: customer_id,
        token: token,
        serviceRequestId: serviceRequestId,
        document_type: document_type,
        document_number: document_number
        // panNumber: panNumber,
      );

      if (response.data != null && response.data.containsKey("status")) {
        if (response.data["status"] == 200) {
          emit(PanVerificationUpdateSuccessState(response.data));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(PanVerificationUpdateErrorState(errorMessage));
        } else {
          emit(PanVerificationUpdateErrorState(
              '${response.data["status"]} \n ${response.data["message"]}'));
        }
      } else {
        emit(PanVerificationUpdateErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(PanVerificationUpdateErrorState('An error occurred:$e'));
    }
  }
}
