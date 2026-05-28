import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_verify/screen/AllFormList/FormList/widgets/EducationVerification/Bloc/education_list_state.dart';
import 'package:v_verify/screen/AllFormList/FormList/widgets/EducationVerification/Model/education_list_model.dart';
import '../../../../../../apiServices/api_services.dart';

class EducationListCubit extends Cubit<EducationDataListState> {
  final ApiService _apiService;

  EducationListCubit(this._apiService) : super(EducationDataListInitialState());

  void educationList({
    required String token,
    required int requestId,
    required int serviceRequestId,
  }) async {
    emit(EducationDataListLoadingState());
    try {
      final response = await _apiService.educationList(
        token: token,
        request_id: requestId,
        service_request_id: serviceRequestId,
      );
      if (response.data != null && response.data.containsKey("status")) {
        EducationListModel educationListDataModel =
            EducationListModel.fromJson(response.data);
        if (response.data["status"] == 200) {
          emit(EducationDataListSuccessState(educationListDataModel));
        } else if (response.data["status"] == 300) {
          emit(EducationDataListEmptyState());
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(EducationDataListErrorState(errorMessage));
        } else {
          emit(EducationDataListErrorState('${response.data["message"]}'));
        }
      } else {
        emit(EducationDataListErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(EducationDataListErrorState('An error occurred: $e'));
    }
  }
}
