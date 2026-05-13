import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_verify/apiServices/api_services.dart';
import 'package:v_verify/screen/VerificationForms/VerifyDeatils/Bloc/verify_details_state.dart';
import 'package:v_verify/screen/VerificationForms/VerifyDeatils/Model/verify_details_model.dart';

class VerifyDetailsCubit extends Cubit<VerifyDetailsState> {
  ApiService _apiService;

  VerifyDetailsCubit(this._apiService) : super(VerifyDetailsInitialState());

  void verifyDetails({required String token, required String requestId}) async {
    emit(VerifyDetailsLoadingState());
    try {
      final response = await _apiService.VerifyDetailsView(
          token: token, request_id: requestId);
      if (response.data != null && response.data.containsKey("status")) {
        VerifyDetailsModel verifyDetailsModel =
            VerifyDetailsModel.fromJson(response.data);
        if (response.data["status"] == 200) {
          emit(VerifyDetailsSuccessState(verifyDetailsModel));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(VerifyDetailsErrorState(errorMessage));
        } else {
          emit(VerifyDetailsErrorState('${response.data["status"]}'));
        }
      } else {
        emit(VerifyDetailsErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(VerifyDetailsErrorState('An error occurred:$e'));
    }
  }
}
