import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_verify/apiServices/api_services.dart';
import 'package:v_verify/screen/VerificationForms/ReferenceForm/Form/Blocs/reference_show_details_bloc/reference_show_details_state.dart';

import '../../Models/non_mumbai_show_details_model.dart';
import 'non_mumbai_show_details_state.dart';


class NonMumbaiShowDataCubit extends Cubit<NonMumbaiShowDataState> {
  ApiService _apiService;

  NonMumbaiShowDataCubit(this._apiService)
      : super(NonMumbaiShowDataInitialState());

  void nonMumbaiShowData({required String token, required String uid}) async {
    emit(NonMumbaiShowDataLoadingState());
    try {
      final response = await _apiService.nonMumbaiShowData(
        token: token,
        uid: uid,
      );
      if (response.data != null && response.data.containsKey("status")) {
        NonMumbaiShowDataModel nonMumbaiShowDataModel =
        NonMumbaiShowDataModel.fromJson(response.data);
        if (response.data["status"] == 200) {
          emit(NonMumbaiShowDataSuccessState(nonMumbaiShowDataModel));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(NonMumbaiShowDataErrorState(errorMessage));
        } else {
          emit(NonMumbaiShowDataErrorState('${response.data["message"]}'));
        }
      } else {
        emit(NonMumbaiShowDataErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(NonMumbaiShowDataErrorState('An error occurred:$e'));
    }
  }
}
