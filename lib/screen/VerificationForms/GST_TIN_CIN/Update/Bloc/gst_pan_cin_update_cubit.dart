import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_verify/apiServices/api_services.dart';

import 'gst_pan_cin_update_state.dart';

class GstPanCinUpdateCubit extends Cubit<GstPanCinUpdateState> {
  ApiService _apiService;

  GstPanCinUpdateCubit(this._apiService) : super(GstPanCinUpdateInitialState());

  void gstPanCinUpdate({
    required String customer_id,
    required String token,
    required String request_id,
    required String service_request_id,
    required String gst_number,
    required String pan_number,
    required String cin_number,
  }) async {
    emit(GstPanCinUpdateLoadingState());
    try {
      final response = await _apiService.gstPanCinUpdate(
        customer_id: customer_id,
        token: token,
        request_id: request_id,
        service_request_id: service_request_id,
        gst_number: gst_number,
        pan_number: pan_number,
        cin_number: cin_number,
      );
      if (response.data != null && response.data.containsKey("status")) {
        if (response.data["status"] == 200) {
          emit(GstPanCinUpdateSuccessState(response.data));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(GstPanCinUpdateErrorState(errorMessage));
        } else {
          emit(GstPanCinUpdateErrorState('${response.data["message"]}'));
        }
      } else {
        emit(GstPanCinUpdateErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(GstPanCinUpdateErrorState('An error occurred:$e'));
    }
  }
}
