import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../apiServices/api_services.dart';
import 'court_doc_update_state.dart';
class CourtDocUpdateCubit extends Cubit<CourtDocUpdateState> {

  ApiService _apiService;
  CourtDocUpdateCubit(this._apiService) : super(CourtDocUpdateInitialState());

  void courtVerificationDocumentUpdate({
    required String customer_id,
    required String token,
    required String request_id,
    required String serviceRequestId,
    required File aadhaar_document,
    required File pan_document,
  }) async {
    emit(CourtDocUpdateLoadingState());
    try {
      final response = await _apiService.courtVerificationDocUpdate(
        customer_id: customer_id,
        token: token,
        request_id: request_id,
        service_request_id: serviceRequestId,
        aadhaar_document: aadhaar_document,
        pan_document: pan_document,
      );

      if (response.data != null && response.data.containsKey("status")) {
        if (response.data["status"] == 200) {
          emit(CourtDocUpdateSuccessState(response.data));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(CourtDocUpdateErrorState(errorMessage));
        } else {
          emit(CourtDocUpdateErrorState(
              '${response.data["status"]} \n ${response.data["message"]}'));
        }
      } else {
        emit(CourtDocUpdateErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(CourtDocUpdateErrorState('An error occurred:$e'));
    }
  }
}

