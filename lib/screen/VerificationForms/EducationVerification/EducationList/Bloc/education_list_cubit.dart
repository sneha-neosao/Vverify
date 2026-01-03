import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../apiServices/api_services.dart';
import '../Model/education_list_model.dart';
import 'education_list_state.dart';

class EducationListCubit extends Cubit<EducationListState> {
  ApiService _apiService;

  EducationListCubit(this._apiService) : super(EducationListInitialState());

  void educationList({
    required String token,
    required int request_id,
    required int service_request_id,
  }) async {
    emit(EducationListLoadingState());
    try {
      final response = await _apiService.educationList(
        token: token,
        request_id: request_id,
        service_request_id: service_request_id,
      );
      if (response.data != null && response.data.containsKey("status")) {
        EducationDocListModel educationListModel =
        EducationDocListModel.fromJson(response.data);
        if (response.data["status"] == 200) {
          emit(EducationListSuccessState(educationListModel));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(EducationListErrorState(errorMessage));
        } else {
          emit(EducationListErrorState('${response.data["message"]}'));
        }
      } else {
        emit(EducationListErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(EducationListErrorState('An error occurred:$e'));
    }
  }
}
