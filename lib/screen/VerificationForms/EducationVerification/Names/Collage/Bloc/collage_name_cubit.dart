import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../apiServices/api_services.dart';
import '../../../../EmploymentForm/EmployList/Model/employ_data_list_model.dart';
import '../model/collage_name_model.dart';
import 'collage_name_state.dart';

class CollageNameCubit extends Cubit<CollageNameState> {
  ApiService _apiService;

  CollageNameCubit(this._apiService) : super(CollageNameInitialState());

  void collageNameList(
      {
        required String token,

      }) async {
    emit(CollageNameLoadingState());
    try {
      final response = await _apiService.collageNameGetData(
        token: token, );
      if (response.data != null && response.data.containsKey("status")) {
        CollageNameModel collageNameModel = CollageNameModel.fromJson(response.data);
        if (response.data["status"] == 200) {
          emit(CollageNameSuccessState(collageNameModel));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(CollageNameErrorState(errorMessage));
        } else {
          emit(CollageNameErrorState('${response.data["message"]}'));
        }
      } else {
        emit(CollageNameErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(CollageNameErrorState('An error occurred:$e'));
    }
  }
}
