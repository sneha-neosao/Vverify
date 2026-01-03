import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_verify/apiServices/api_services.dart';

import 'name_address_doc_update_state.dart';

class NameAddressDocUpdateCubit extends Cubit<NameAddressDocUpdateState> {
  ApiService _apiService;

  NameAddressDocUpdateCubit(this._apiService)
      : super(NameAddressDocUpdateInitialState());

  void nameAddressDocUpdate({
    required String customerId,
    required String token,
    required String requestId,
    required String serviceRequestId,
    required File aadhaar_front_side,
    required File aadhaar_back_side,
  }) async {
    emit(NameAddressDocUpdateLoadingState());
    try {
      final response = await _apiService.nameAddressDocUpdate(
        customerId: customerId,
        token: token,
        request_id: requestId,
        service_request_id: serviceRequestId,
        aadhaar_front_side: aadhaar_front_side,
        aadhaar_back_side: aadhaar_back_side,
      );
      if (response.data != null && response.data.containsKey("status")) {
        if (response.data["status"] == 200) {
          emit(NameAddressDocUpdateSuccessState(response.data));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(NameAddressDocUpdateErrorState(errorMessage));
        } else {
          emit(NameAddressDocUpdateErrorState('${response.data["message"]}'));
        }
      } else {
        emit(NameAddressDocUpdateErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(NameAddressDocUpdateErrorState('An error occurred:$e'));
    }
  }
}
