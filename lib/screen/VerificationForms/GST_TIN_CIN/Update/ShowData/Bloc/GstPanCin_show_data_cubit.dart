import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_verify/apiServices/api_services.dart';

import '../Model/GstPanCin_show_data_model.dart';
import 'GstPanCin_show_data_state.dart';

class GstPanCinShowDataCubit extends Cubit<GstPanCinShowDataState> {
  ApiService _apiService;

  GstPanCinShowDataCubit(this._apiService)
      : super(GstPanCinShowDataInitialState());

  void gstPanCinShowData({
    required String token,
    required String uid,
  }) async {
    emit(GstPanCinShowDataLoadingState());
    try {
      final response = await _apiService.gstPanCinShowData(
        token: token,
        uid: uid,
      );
      if (response.data != null && response.data.containsKey("status")) {
        GstPanCinShowDataModel gstPanCinShowDataModel =
            GstPanCinShowDataModel.fromJson(response.data);
        if (response.data["status"] == 200) {
          emit(GstPanCinShowDataSuccessState(gstPanCinShowDataModel));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(GstPanCinShowDataErrorState(errorMessage));
        } else {
          emit(GstPanCinShowDataErrorState('${response.data["message"]}'));
        }
      } else {
        emit(GstPanCinShowDataErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(GstPanCinShowDataErrorState('An error occurred:$e'));
    }
  }
}
