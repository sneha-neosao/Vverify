import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_verify/apiServices/api_services.dart';
import '../../../../NonMumbai/Document/Blocs/non_mumbai_document_show_details_bloc/non_mumbai_show_details_state.dart';
import '../../../../NonMumbai/Document/Models/non_mumbai_show_details_model.dart';
import '../../Models/mumbai_document_show_details_model.dart';
import 'mumbai_document_show_details_state.dart';

class MumbaiDocShowDataCubit
    extends Cubit<MumbaiDocShowDataState> {
  ApiService _apiService;

  MumbaiDocShowDataCubit(this._apiService)
      : super(MumbaiDocShowDataInitialState());

  void mumbaiDocumentShowData(
      {
        required String token,
        required String uid,
      }) async {
    emit(MumbaiDocShowDataLoadingState());
    try {
      final response = await _apiService.mumbaiDocumentShowData(
        token: token, uid: uid,
      );
      if (response.data != null && response.data.containsKey("status")) {
        MumbaiDocShowDataModel mumbaiDocShowDataModel = MumbaiDocShowDataModel.fromJson(response.data);
        if (response.data["status"] == 200) {
          emit(MumbaiDocShowDataSuccessState(mumbaiDocShowDataModel));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(MumbaiDocShowDataErrorState(errorMessage));
        } else {
          emit(MumbaiDocShowDataErrorState(
              'uploadDocuments failed with status: ${response.data["status"]}'));
        }
      } else {
        emit(MumbaiDocShowDataErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(MumbaiDocShowDataErrorState('An error occurred:$e'));
    }
  }
}
