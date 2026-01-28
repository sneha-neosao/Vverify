import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_verify/screen/VerificationForms/PanVerification/Form/Blocs/pan_save_form_bloc/pan_save_form_state.dart';

import '../../../../../../apiServices/api_services.dart';

class PanVerificationSaveBloc extends Cubit<PanVerificationSaveState> {
  ApiService _apiService;

  PanVerificationSaveBloc(this._apiService)
      : super(PanVerificationSaveInitialState());

  void panCardNumberSave({
    required String token,
    required String serviceRequestId,
    required String requestId,
    required String customer_id,
    required String document_type,
    required String document_number
    // required String panNumber,
  }) async {
    emit(PanVerificationSaveLoadingState());
    try {
      final response = await _apiService.panNumberSave(
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
          emit(PanVerificationSaveSuccessState(response.data));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(PanVerificationSaveErrorState(errorMessage));
        } else {
          emit(PanVerificationSaveErrorState(
              '${response.data["status"]} \n ${response.data["message"]}'));
        }
      } else {
        emit(PanVerificationSaveErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(PanVerificationSaveErrorState('An error occurred:$e'));
    }
  }
}

class FormUploadPanCubit extends Cubit<bool> {
  FormUploadPanCubit() : super(false);

  void formUploadYesNo({required bool yesNo}) {
    emit(yesNo);
  }
}