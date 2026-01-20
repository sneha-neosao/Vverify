import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_verify/apiServices/api_services.dart';
import 'package:v_verify/screen/VerificationForms/ReferenceForm/Form/Blocs/reference_show_details_bloc/reference_show_details_state.dart';

import '../../Models/reference_show_details_model.dart';

class ReferenceCheckDetailsCubit extends Cubit<ReferenceCheckDetailsState> {
  ApiService _apiService;

  ReferenceCheckDetailsCubit(this._apiService)
      : super(ReferenceCheckDetailsInitialState());

  void referenceDetails({required String token, required String uid}) async {
    emit(ReferenceCheckDetailsLoadingState());
    try {
      final response = await _apiService.ReferenceCheckDetailsView(
        token: token,
        uid: uid,
      );
      if (response.data != null && response.data.containsKey("status")) {
        ReferenceCheckDetailsModel referenceCheckDetailsModel =
            ReferenceCheckDetailsModel.fromJson(response.data);
        if (response.data["status"] == 200) {
          emit(ReferenceCheckDetailsSuccessState(referenceCheckDetailsModel));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(ReferenceCheckDetailsErrorState(errorMessage));
        } else {
          emit(ReferenceCheckDetailsErrorState('${response.data["status"]}'));
        }
      } else {
        emit(ReferenceCheckDetailsErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(ReferenceCheckDetailsErrorState('An error occurred:$e'));
    }
  }
}
