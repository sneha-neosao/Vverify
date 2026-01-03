import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_verify/apiServices/api_services.dart';
import 'gst_pan_cin_doc_update_state.dart';


class GstPanCinDocUpdateCubit extends Cubit<GstPanCinDocUpdateState> {
  ApiService _apiService;

  GstPanCinDocUpdateCubit(this._apiService)
      : super(GstPanCinDocUpdateInitialState());

  void gstPanCinDocUpdate({
    required String token,
    required String customer_id,
    required String request_id,
    required String service_request_id,
    required File gst_document,
    required File pan_document,
    required File cin_document,
  }) async {
    emit(GstPanCinDocUpdateLoadingState());
    try {
      final response = await _apiService.gstPanCinDocUpdate(
        customer_id: customer_id,
        token: token,
        request_id: request_id,
        service_request_id: service_request_id,
        gst_document: gst_document,
        pan_document: pan_document,
        cin_document: cin_document,
      );

      if (response.data != null && response.data.containsKey("status")) {
        if (response.data["status"] == 200) {
          emit(GstPanCinDocUpdateSuccessState(response.data));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(GstPanCinDocUpdateErrorState(errorMessage));
        } else {
          emit(GstPanCinDocUpdateErrorState('${response.data["message"]}'));
        }
      } else {
        emit(GstPanCinDocUpdateErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(GstPanCinDocUpdateErrorState('An error occurred:$e'));
    }
  }
}


