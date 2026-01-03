import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_verify/apiServices/api_services.dart';
import 'package:v_verify/screen/VerificationForms/ReferenceForm/DocUpload/UpdateDoc/ShowData/Bloc/reference_doc_show_data_state.dart';

import '../model/reference_doc_show_data_model.dart';

class ReferenceDocShowDataCubit extends Cubit<ReferenceDocShowDataState> {
  ApiService _apiService;

  ReferenceDocShowDataCubit(this._apiService)
      : super(ReferenceDocShowDataInitialState());

  void referenceUploadDoc({
    required String token,
    required String uid,
  }) async {
    emit(ReferenceDocShowDataLoadingState());
    try {
      final response = await _apiService.referenceCheckDocShowData(
        token: token,
        uid: uid,
      );
      if (response.data != null && response.data.containsKey("status")) {
        ReferenceDocShowDataModel referenceDocShowDataModel =
            ReferenceDocShowDataModel.fromJson(response.data);
        if (response.data["status"] == 200) {
          emit(ReferenceDocShowDataSuccessState(referenceDocShowDataModel));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(ReferenceDocShowDataErrorState(errorMessage));
        } else {
          emit(ReferenceDocShowDataErrorState('${response.data["message"]}'));
        }
      } else {
        emit(ReferenceDocShowDataErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(ReferenceDocShowDataErrorState('An error occurred:$e'));
    }
  }
}
