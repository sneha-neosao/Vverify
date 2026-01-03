import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_verify/screen/VerificationForms/EducationVerification/Names/University/Bloc/university_name_state.dart';

import '../../../../../../apiServices/api_services.dart';
import '../model/university_name_state.dart';

class UniversityNameBloc extends Cubit<UniversityNameState> {
  ApiService _apiService;

  UniversityNameBloc(this._apiService) : super(UniversityNameInitialState());

  void universityList({
    required String token,
  }) async {
    emit(UniversityNameLoadingState());
    try {
      final response = await _apiService.universityNameGetData(
        token: token,
      );
      if (response.data != null && response.data.containsKey("status")) {
        UniversityNameModel universityNameModel =
            UniversityNameModel.fromJson(response.data);
        if (response.data["status"] == 200) {
          emit(UniversityNameSuccessState(universityNameModel));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(UniversityNameErrorState(errorMessage));
        } else {
          emit(UniversityNameErrorState('${response.data["message"]}'));
        }
      } else {
        emit(UniversityNameErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(UniversityNameErrorState('An error occurred:$e'));
    }
  }
}
