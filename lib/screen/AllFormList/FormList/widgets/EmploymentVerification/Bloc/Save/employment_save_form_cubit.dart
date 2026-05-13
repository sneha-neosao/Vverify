import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../apiServices/api_services.dart';
import '../../Model/employment_save_form_model.dart';
import 'employment_save_form_state.dart';

class EmploymentSaveFormCubit extends Cubit<EmploymentSaveFormState> {
  ApiService _apiService;

  EmploymentSaveFormCubit(this._apiService)
      : super(EmploymentSaveFormInitialState());

  void employmentSaveForm(
      {required String token,
      required String customer_id,
      required EmploymentSaveFormModel employmentSaveFormModel}) async {
    emit(EmploymentSaveFormLoadingState());
    try {
      final response = await _apiService.EmploymentSaveForm(
          token: token,
          customer_id: customer_id,
          employmentSaveFormModel: employmentSaveFormModel);
      if (response.data != null && response.data.containsKey("status")) {
        if (response.data["status"] == 200) {
          emit(EmploymentSaveFormSuccessState(response.data));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(EmploymentSaveFormErrorState(errorMessage));
        } else {
          emit(EmploymentSaveFormErrorState('${response.data["message"]}'));
        }
      } else {
        emit(EmploymentSaveFormErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(EmploymentSaveFormErrorState('An error occurred:$e'));
    }
  }
}
