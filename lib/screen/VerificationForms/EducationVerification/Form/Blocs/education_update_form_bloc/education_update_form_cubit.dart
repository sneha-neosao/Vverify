import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_verify/screen/VerificationForms/EducationVerification/Form/Blocs/education_update_form_bloc/education_update_form_state.dart';
import '../../../../../../../apiServices/api_services.dart';
import '../../Models/education_update_form_model.dart';

class EducationUpdateFormCubit extends Cubit<EducationUpdateFormState> {
  ApiService _apiService;

  EducationUpdateFormCubit(this._apiService)
      : super(EducationUpdateFormInitialState());

  void educationUpdateForm(
      {
        required String token,
        required String customer_id,
      required EducationUpdateFormModel educationUpdateFormModel}) async {
    emit(EducationUpdateFormLoadingState());
    try {
      final response = await _apiService.EducationFormUpdate(
        customer_id: customer_id,
        token: token,
        educationUpdateFormModel: educationUpdateFormModel,
      );
      if (response.data != null && response.data.containsKey("status")) {
        if (response.data["status"] == 200) {
          emit(EducationUpdateFormSuccessState(response.data));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(EducationUpdateFormErrorState(errorMessage));
        } else {
          emit(EducationUpdateFormErrorState('${response.data["message"]}'));
        }
      } else {
        emit(EducationUpdateFormErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(EducationUpdateFormErrorState('An error occurred:$e'));
    }
  }
}
