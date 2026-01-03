import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../apiServices/api_services.dart';
import '../../UploadDocuments/Model/upload_documents_mumbai.dart';
import '../../UploadDocuments/bloc/upload_documents_mumbai_state.dart';
import '../Model/mumbai_doc_update_model.dart';
import 'mumbai_doc_update_state.dart';

class MumbaiDocUpdateCubit extends Cubit<MumbaiDocUpdateState> {
  ApiService _apiService;

  MumbaiDocUpdateCubit(this._apiService)
      : super(MumbaiDocUpdateInitialState());

  void uploadDocumentsMumbai(
      {
        required String token,
        required String customer_id,
        required UpdateDocumentsMumbaiModel updateDocumentsMumbaiModel}) async {
    emit(MumbaiDocUpdateLoadingState());
    try {
      final response = await _apiService.tenantMumbaiUpdateDocuments(
          customer_id: customer_id,
          token: token,
          updateDocumentsMumbaiModel: updateDocumentsMumbaiModel);

      if (response.data != null && response.data.containsKey("status")) {
        if (response.data["status"] == 200) {
          emit(MumbaiDocUpdateSuccessState(response.data));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(MumbaiDocUpdateErrorState(errorMessage));
        } else {
          emit(MumbaiDocUpdateErrorState(
              'uploadDocuments failed with status: ${response.data["status"]}'));
        }
      } else {
        emit(MumbaiDocUpdateErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(MumbaiDocUpdateErrorState('An error occurred:$e'));
    }
  }
}