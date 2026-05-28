import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_verify/screen/AllFormList/FormList/widgets/AadhaarVerificationDigilocker/model/pan_show_details_model.dart';
import '../../../../../../../apiServices/api_services.dart';
import 'aadhaar_show_details_state.dart';

class AadhaarVerificationShowCubit extends Cubit<AadhaarVerificationShowState> {
  final ApiService _apiService;

  AadhaarVerificationShowCubit(this._apiService)
      : super(AadhaarVerificationShowInitialState());

  void fetchAadhaarDetails({
    required String token,
    required String uid,
  }) async {
    emit(AadhaarVerificationShowLoadingState());
    try {
      final response = await _apiService.panNumberShowData(
        token: token,
        uid: uid,
      );

      if (response.data != null && response.data.containsKey("status")) {
        if (response.data["status"] == 200) {
          final model = PanVerificationShowModel.fromJson(response.data);
          emit(AadhaarVerificationShowSuccessState(model));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(AadhaarVerificationShowErrorState(errorMessage));
        } else {
          emit(AadhaarVerificationShowErrorState(
              '${response.data["status"]} \n ${response.data["message"]}'));
        }
      } else {
        emit(AadhaarVerificationShowErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(AadhaarVerificationShowErrorState('An error occurred: $e'));
    }
  }
}
