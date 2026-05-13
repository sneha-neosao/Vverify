import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../apiServices/api_services.dart';
import '../../Model/employment_update_form_model.dart';
import 'employment_update_form_state.dart';

class EmploymentUpdateFormCubit extends Cubit<EmploymentUpdateFormState> {
  ApiService _apiService;

  EmploymentUpdateFormCubit(this._apiService)
      : super(EmploymentUpdateFormInitialState());

  void employmentUpdateForm(
      {required String token,
      required String customer_id,
      required EmploymentUpdateFormModel employmentUpdateFormModel}) async {
    emit(EmploymentUpdateFormLoadingState());
    try {
      final response = await _apiService.employmentUpdateForm(
        customer_id: customer_id,
        token: token,
        employmentUpdateFormModel: employmentUpdateFormModel,
      );
      if (response.data != null && response.data.containsKey("status")) {
        if (response.data["status"] == 200) {
          emit(EmploymentUpdateFormSuccessState(response.data));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(EmploymentUpdateFormErrorState(errorMessage));
        } else {
          emit(EmploymentUpdateFormErrorState('${response.data["message"]}'));
        }
      } else {
        emit(EmploymentUpdateFormErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(EmploymentUpdateFormErrorState('An error occurred:$e'));
    }
  }
}
