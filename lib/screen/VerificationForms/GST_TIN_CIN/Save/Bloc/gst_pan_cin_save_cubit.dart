import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_verify/apiServices/api_services.dart';

import 'gst_pan_cin_save_state.dart';

class GstPanCinSaveCubit extends Cubit<GstPanCinSaveState> {
  ApiService _apiService;

  GstPanCinSaveCubit(this._apiService) : super(GstPanCinSaveInitialState());

  void gstPanCinSaveData(
      {
        required String token,
        required String customer_id,
      required String request_id,
      required String service_request_id,
      required String gst_number,
      required String pan_number,
      required String cin_number,
     }) async {
    emit(GstPanCinSaveLoadingState());
    try {
      final response = await _apiService.gstPanCinSave(
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
          emit(GstPanCinSaveSuccessState(response.data));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(GstPanCinSaveErrorState(errorMessage));
        } else {
          emit(GstPanCinSaveErrorState('${response.data["message"]}'));
        }
      } else {
        emit(GstPanCinSaveErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(GstPanCinSaveErrorState('An error occurred:$e'));
    }
  }
}

class FormUploadGstPanCinCubit extends Cubit<bool> {
  FormUploadGstPanCinCubit() : super(false);

  void formUploadYesNo({required bool yesNo}) {
    emit(yesNo);
  }
}
