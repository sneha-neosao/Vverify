import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_verify/apiServices/api_services.dart';
import 'name_address_doc_upload_state.dart';

class NameAddressDocUploadCubit extends Cubit<NameAddressDocUploadState> {
  ApiService _apiService;

  NameAddressDocUploadCubit(this._apiService)
      : super(NameAddressDocUploadInitialState());

  void nameAddressDocUpload({
    required String token,
    required String customer_id,
    required String requestId,
    required String serviceRequestId,
    required File aadhaar_front_side,
    required File aadhaar_back_side,
  }) async {
    emit(NameAddressDocUploadLoadingState());
    try {
      final response = await _apiService.nameAddressDocUpload(
        customer_id: customer_id,
        token: token,
        request_id: requestId,
        service_request_id: serviceRequestId,
        aadhaar_front_side: aadhaar_front_side,
        aadhaar_back_side: aadhaar_back_side,
      );
      if (response.data != null && response.data.containsKey("status")) {
        if (response.data["status"] == 200) {
          emit(NameAddressDocUploadSuccessState(response.data));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(NameAddressDocUploadErrorState(errorMessage));
        } else {
          emit(NameAddressDocUploadErrorState('${response.data["message"]}'));
        }
      } else {
        emit(NameAddressDocUploadErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(NameAddressDocUploadErrorState('An error occurred:$e'));
    }
  }
}
