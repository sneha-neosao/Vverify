import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:v_verify/apiServices/api_services.dart';
import 'package:v_verify/screen/VerificationForms/ReferenceForm/DocUpload/uploadDoc/Bloc/reference_upload_doc_state.dart';

class ReferenceUploadDocCubit extends Cubit<ReferenceUploadDocState> {
  ApiService _apiService;

  ReferenceUploadDocCubit(this._apiService)
      : super(ReferenceUploadDocInitialState());

  void referenceUploadDoc({
    required String token,
    required String customer_id,
    required String requestId,
    required String serviceRequestId,
    required File dataDocument,
  }) async {
    emit(ReferenceUploadDocLoadingState());
    try {
      final response = await _apiService.referenceCheckDocUpload(
        token: token,
        customer_id: customer_id,
        request_id: requestId,
        service_request_id: serviceRequestId,
        data_document: dataDocument,
      );
      if (response.data != null && response.data.containsKey("status")) {
        if (response.data["status"] == 200) {
          emit(ReferenceUploadDocSuccessState(response.data));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(ReferenceUploadDocErrorState(errorMessage));
        } else {
          emit(ReferenceUploadDocErrorState('${response.data["message"]}'));
        }
      } else {
        emit(ReferenceUploadDocErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(ReferenceUploadDocErrorState('An error occurred:$e'));
    }
  }
}

class ReferenceCheckUploadDoc extends Cubit<File> {

  ReferenceCheckUploadDoc() : super(File(""));
  final ImagePicker _picker = ImagePicker();

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', "png", "jpg", "jpeg"],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      // You can access the file path and name like this
      emit(file);
    } else {
      //User canceled the picker
    }
  }
  // Pick an image using the camera
  Future<void> pickImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      emit(File(image.path));
      // _image = File(image.path);
      
    }
  }

  void clearImage() {
    emit(File(""));
  }
}

