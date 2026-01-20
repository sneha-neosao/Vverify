import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_verify/apiServices/api_services.dart';
import 'package:v_verify/screen/VerificationForms/ReferenceForm/Documents/Blocs/reference_document_update_bloc/reference_doc_update_state.dart';

class ReferenceDocUpdateCubit extends Cubit<ReferenceDocUpdateState> {
  ApiService _apiService;

  ReferenceDocUpdateCubit(this._apiService)
      : super(ReferenceDocUpdateInitialState());

  void referenceDocUpdate({
    required String token,
    required String customer_id,
    required String requestId,
    required String serviceRequestId,
    required File dataDocument,
  }) async {
    emit(ReferenceDocUpdateLoadingState());
    try {
      final response = await _apiService.referenceCheckDocUpdate(
        customer_id: customer_id,
        token: token,
        request_id: requestId,
        service_request_id: serviceRequestId,
        data_document: dataDocument,
      );
      if (response.data != null && response.data.containsKey("status")) {
        if (response.data["status"] == 200) {
          emit(ReferenceDocUpdateSuccessState(response.data));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(ReferenceDocUpdateErrorState(errorMessage));
        } else {
          emit(ReferenceDocUpdateErrorState('${response.data["message"]}'));
        }
      } else {
        emit(ReferenceDocUpdateErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(ReferenceDocUpdateErrorState('An error occurred:$e'));
    }
  }
}
