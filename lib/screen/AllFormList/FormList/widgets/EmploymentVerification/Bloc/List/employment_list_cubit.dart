import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../apiServices/api_services.dart';
import '../../Model/employment_list_model.dart';
import 'employment_list_state.dart';

class EmployDataListCubit extends Cubit<EmployDataListState> {
  final ApiService _apiService;

  EmployDataListCubit(this._apiService) : super(EmployDataListInitialState());

  void employmentList({
    required String token,
    required int requestId,
    required int serviceRequestId,
  }) async {
    emit(EmployDataListLoadingState());
    try {
      final response = await _apiService.employmentList(
        token: token,
        request_id: requestId,
        service_request_id: serviceRequestId,
      );
      if (response.data != null && response.data.containsKey("status")) {
        EmployListDataModel employListDataModel =
            EmployListDataModel.fromJson(response.data);
        if (response.data["status"] == 200) {
          emit(EmployDataListSuccessState(employListDataModel));
        } else if (response.data["status"] == 300) {
          emit(EmployDataListEmptyState());
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(EmployDataListErrorState(errorMessage));
        } else {
          emit(EmployDataListErrorState('${response.data["message"]}'));
        }
      } else {
        emit(EmployDataListErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(EmployDataListErrorState('An error occurred:$e'));
    }
  }
}
