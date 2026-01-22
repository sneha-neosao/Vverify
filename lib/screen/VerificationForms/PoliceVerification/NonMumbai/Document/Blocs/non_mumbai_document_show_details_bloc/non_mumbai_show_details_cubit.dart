import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_verify/apiServices/api_services.dart';
import '../../Models/non_mumbai_show_details_model.dart';
import 'non_mumbai_show_details_state.dart';

class NonMumbaiDocShowDataCubit
    extends Cubit<NonMumbaiDocShowDataState> {
  ApiService _apiService;

  NonMumbaiDocShowDataCubit(this._apiService)
      : super(NonMumbaiDocShowDataInitialState());

  void nonMumbaiDocumentShowData(
      {
        required String token,
        required String uid,
       }) async {
    emit(NonMumbaiDocShowDataLoadingState());
    try {
      final response = await _apiService.nonMumbaiDocumentShowData(
          token: token, uid: uid,
          );

      if (response.data != null && response.data.containsKey("status")) {
        NonMumbaiDocShowDataModel nonMumbaiDocShowDataModel = NonMumbaiDocShowDataModel.fromJson(response.data);
        if (response.data["status"] == 200) {
          emit(NonMumbaiDocShowDataSuccessState(nonMumbaiDocShowDataModel));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(NonMumbaiDocShowDataErrorState(errorMessage));
        } else {
          emit(NonMumbaiDocShowDataErrorState(
              'uploadDocuments failed with status: ${response.data["status"]}'));
        }
      } else {
        emit(NonMumbaiDocShowDataErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(NonMumbaiDocShowDataErrorState('An error occurred:$e'));
    }
  }
}
