import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_verify/screen/VerificationForms/PanVerification/update/show/Bloc/pan_verification_show_state.dart';

import '../../../../../../apiServices/api_services.dart';
import '../model/pan_verification_show_model.dart';

class PanVerificationShowCubit extends Cubit<PanVerificationShowState> {
  ApiService _apiService;

  PanVerificationShowCubit(this._apiService)
      : super(PanVerificationShowInitialState());

  void panCardNumberShow({
    required String token,
    required String uid,
    required String request_id,
    required String service_request_id,
    required String customer_id,
  }) async {
    emit(PanVerificationShowLoadingState());
    try {
      final response = await _apiService.panNumberShowData(
          token: token,
          uid: uid,
          request_id: request_id,
          service_request_id: service_request_id,
          customer_id: customer_id);

      if (response.data != null && response.data.containsKey("status")) {
        if (response.data["status"] == 200) {
          PanVerificationShowModel panVerificationShowModel =
              PanVerificationShowModel.fromJson(response.data);
          emit(PanVerificationShowSuccessState(panVerificationShowModel));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(PanVerificationShowErrorState(errorMessage));
        } else {
          emit(PanVerificationShowErrorState(
              '${response.data["status"]} \n ${response.data["message"]}'));
        }
      } else {
        emit(PanVerificationShowErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(PanVerificationShowErrorState('An error occurred:$e'));
    }
  }
}
