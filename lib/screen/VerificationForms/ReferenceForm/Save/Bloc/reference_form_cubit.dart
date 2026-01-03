import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_verify/apiServices/api_services.dart';
import 'package:v_verify/screen/VerificationForms/ReferenceForm/Save/Bloc/reference_form_state.dart';

import '../Model/Reference_model.dart';

class ReferenceFormCubit extends Cubit<ReferenceVerificationState> {
  ApiService _apiService;

  ReferenceFormCubit(this._apiService)
      : super(ReferenceVerificationInitialState());

  void referenceForm(
      {
        required String token,
        required String customer_id,
        required ReferenceModel referenceModel}) async {
    emit(ReferenceVerificationLoadingState());
    try {
      final response = await _apiService.ReferenceVerification(
          customer_id: customer_id,
          token: token,
          referenceModel: referenceModel);
      if (response.data != null && response.data.containsKey("status")) {
        if (response.data["status"] == 200) {
          emit(ReferenceVerificationSuccessState(response.data));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(ReferenceVerificationErrorState(errorMessage));
        } else {
          emit(ReferenceVerificationErrorState('${response.data["message"]}'));
        }
      } else {
        emit(ReferenceVerificationErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(ReferenceVerificationErrorState('An error occurred:$e'));
    }
  }
}

class FormUploadReferenceCubit extends Cubit<bool> {
  FormUploadReferenceCubit() : super(false);

  void formUploadYesNo({required bool yesNo}) {
    emit(yesNo);
  }
}