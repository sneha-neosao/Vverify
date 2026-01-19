import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../apiServices/api_services.dart';
import 'court_verification_save_form_state.dart';

class CourtVerificationCubit extends Cubit<CourtVerificationState> {
  ApiService _apiService;

  CourtVerificationCubit(this._apiService)
      : super(CourtVerificationInitialState());

  void courtVerificationForm({
    required String customer_id,
    required String token,
    required String request_id,
    required String serviceRequestId,
    required String first_name,
    required String last_name,
    required String father_name,
    required String dob,
    required String address,
  }) async {
    emit(CourtVerificationLoadingState());
    try {
      final response = await _apiService.courtVerification(
        customer_id: customer_id,
        token: token,
        request_id: request_id,
        service_request_id: serviceRequestId,
        first_name: first_name,
        last_name: last_name,
        father_name: first_name,
        dob: dob,
        address: address,
      );

      if (response.data != null && response.data.containsKey("status")) {
        if (response.data["status"] == 200) {
          emit(CourtVerificationSuccessState(response.data));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(CourtVerificationErrorState(errorMessage));
        } else {
          emit(CourtVerificationErrorState(
              '${response.data["status"]} \n ${response.data["message"]}'));
        }
      } else {
        emit(CourtVerificationErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(CourtVerificationErrorState('An error occurred:$e'));
    }
  }
}

class FormUploadCourtCubit extends Cubit<bool> {
  FormUploadCourtCubit() : super(false);

  void formUploadYesNo({required bool yesNo}) {
    emit(yesNo);
  }
}