import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_verify/apiServices/api_services.dart';
import 'package:v_verify/screen/VerificationForms/ReferenceForm/Form/Blocs/reference_show_details_bloc/reference_show_details_state.dart';
import '../../Models/mumbai_police_show_details_model.dart';
import 'mumbai_police_show_details_state.dart';

class MumbaiShowDataCubit extends Cubit<MumbaiShowDataState> {
  ApiService _apiService;

  MumbaiShowDataCubit(this._apiService)
      : super(MumbaiShowDataInitialState());

  void mumbaiShowData({required String token, required String uid}) async {
    emit(MumbaiShowDataLoadingState());
    try {
      final response = await _apiService.mumbaiShowData(
        token: token,
        uid: uid,
      );
      if (response.data != null && response.data.containsKey("status")) {
        MumbaiShowDataModel mumbaiShowDataModel =
        MumbaiShowDataModel.fromJson(response.data);
        if (response.data["status"] == 200) {
          emit(MumbaiShowDataSuccessState(mumbaiShowDataModel));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(MumbaiShowDataErrorState(errorMessage));
        } else {
          emit(MumbaiShowDataErrorState('${response.data["status"]}'));
        }
      } else {
        emit(MumbaiShowDataErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(MumbaiShowDataErrorState('An error occurred:$e'));
    }
  }
}
