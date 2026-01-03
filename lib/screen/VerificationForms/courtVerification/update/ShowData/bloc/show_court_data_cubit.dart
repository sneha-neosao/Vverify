import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_verify/screen/VerificationForms/courtVerification/update/ShowData/bloc/show_court_data_state.dart';
import '../../../../../../apiServices/api_services.dart';
import '../Model/show_court_data_model.dart';

class ShowCourtDataCubit extends Cubit<ShowCourtDataState> {
  ApiService _apiService;

  ShowCourtDataCubit(this._apiService) : super(ShowCourtDataInitialState());

  void courtVerificationShowData({
    required String token,
    required String uid,
  }) async {
    emit(ShowCourtDataLoadingState());
    try {
      final response = await _apiService.courtShowData(
        token: token,
        uid: uid,
      );

      if (response.data != null && response.data.containsKey("status")) {
        ShowCourtDataModel showCourtDataModel =
            ShowCourtDataModel.fromJson(response.data);
        if (response.data["status"] == 200) {
          emit(ShowCourtDataSuccessState(showCourtDataModel));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(ShowCourtDataErrorState(errorMessage));
        } else {
          emit(ShowCourtDataErrorState(
              '${response.data["status"]} \n ${response.data["message"]}'));
        }
      } else {
        emit(ShowCourtDataErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(ShowCourtDataErrorState('An error occurred:$e'));
    }
  }
}
