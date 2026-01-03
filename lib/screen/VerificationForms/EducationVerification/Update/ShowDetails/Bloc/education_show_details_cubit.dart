import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../apiServices/api_services.dart';
import '../Model/education_show_details_model.dart';
import 'education_show_details_state.dart';

class EducationShowDetailsCubit extends Cubit<EducationShowDetailsState> {
  ApiService _apiService;

  EducationShowDetailsCubit(this._apiService)
      : super(EducationShowDetailsInitialState());

  void educationUpdateForm(
      {required String token,
        required String uid}) async {
    emit(EducationShowDetailsLoadingState());
    try {
      final response = await _apiService.educationShowDataDetails(
        token: token, uid:uid,

      );
      if (response.data != null && response.data.containsKey("status")) {
        if (response.data["status"] == 200) {
          EducationDataDetailsModel educationDataDetailsModel = EducationDataDetailsModel.fromJson(response.data);
          emit(EducationShowDetailsSuccessState(educationDataDetailsModel));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(EducationShowDetailsErrorState(errorMessage));
        } else {
          emit(EducationShowDetailsErrorState('${response.data["message"]}'));
        }
      } else {
        emit(EducationShowDetailsErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(EducationShowDetailsErrorState('An error occurred:$e'));
    }
  }
}
