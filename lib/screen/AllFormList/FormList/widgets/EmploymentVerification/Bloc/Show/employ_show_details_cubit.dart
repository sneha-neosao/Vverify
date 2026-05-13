import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../apiServices/api_services.dart';
import '../../Model/employment_show_details_model.dart';
import 'employ_show_details_state.dart';

class EmployShowDataCubit extends Cubit<EmployShowDataState> {
  ApiService _apiService;

  EmployShowDataCubit(this._apiService) : super(EmployShowDataInitialState());

  void employShowData({required String token, required String uid}) async {
    emit(EmployShowDataLoadingState());
    try {
      final response = await _apiService.employShowData(
        token: token,
        uid: uid,
      );
      if (response.data != null && response.data.containsKey("status")) {
        if (response.data["status"] == 200) {
          EmploymentShowDataModel employmentShowDataModel =
              EmploymentShowDataModel.fromJson(response.data);
          emit(EmployShowDataSuccessState(employmentShowDataModel));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(EmployShowDataErrorState(errorMessage));
        } else {
          emit(EmployShowDataErrorState('${response.data["message"]}'));
        }
      } else {
        emit(EmployShowDataErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(EmployShowDataErrorState('An error occurred:$e'));
    }
  }
}
