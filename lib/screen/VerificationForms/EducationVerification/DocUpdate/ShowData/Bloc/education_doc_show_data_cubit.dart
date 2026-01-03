import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../apiServices/api_services.dart';
import '../Model/education_show_doc_model.dart';
import 'education_doc_show_data_state.dart';

class EducationDocShowDataCubit extends Cubit<EducationDocShowDataState> {
  ApiService _apiService;

  EducationDocShowDataCubit(this._apiService)
      : super(EducationDocShowDataInitialState());

  void educationDocShowData({
    required String token,
    required String uid,
  }) async {
    emit(EducationDocShowDataLoadingState());
    try {
      final response =
          await _apiService.educationDocShowData(token: token, uid: uid);
      if (response.data != null && response.data.containsKey("status")) {
        EducationShowDocModel educationShowDocModel = EducationShowDocModel.fromJson(response.data);
        if (response.data["status"] == 200) {
          emit(EducationDocShowDataSuccessState(educationShowDocModel));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(EducationDocShowDataErrorState(errorMessage));
        } else {
          emit(EducationDocShowDataErrorState('${response.data["message"]}'));
        }
      } else {
        emit(EducationDocShowDataErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(EducationDocShowDataErrorState('An error occurred:$e'));
    }
  }
}
