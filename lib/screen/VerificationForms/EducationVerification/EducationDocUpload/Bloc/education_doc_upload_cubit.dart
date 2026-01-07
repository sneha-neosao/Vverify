import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../apiServices/api_services.dart';
import 'education_doc_upload_state.dart';

class EducationDocUploadCubit extends Cubit<EducationDocUploadState> {
  ApiService _apiService;

  EducationDocUploadCubit(this._apiService)
      : super(EducationDocUploadInitialState());

  void educationDocUpload({
    required String customer_id,
    required String token,
    required String request_id,
    required String service_request_id,
    required File document,
  }) async {
    emit(EducationDocUploadLoadingState());
    try {
      final response = await _apiService.EducationDocUpload(
        customer_id: customer_id,
        token: token,
        request_id: request_id,
        service_request_id: service_request_id,
        document: document,
      );
      if (response.data != null && response.data.containsKey("status")) {
        if (response.data["status"] == 200) {
          emit(EducationDocUploadSuccessState(response.data));
        } else if (response.data["status"] == 500) {
          final errorMessage = response.data['message'] ?? 'Unknown error occurred.';
          emit(EducationDocUploadErrorState(errorMessage));
        } else {
          emit(EducationDocUploadErrorState('${response.data["message"]}'));
        }
      } else {
        emit(EducationDocUploadErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(EducationDocUploadErrorState('An error occurred:$e'));
    }
  }
}

class EducationDocFileCubit extends Cubit<File> {
  EducationDocFileCubit() : super(File(""));

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      compressionQuality: 50,
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


  final ImagePicker _picker = ImagePicker();
  // Pick an image using the camera
  Future<void> pickImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera,imageQuality: 50);
    if (image != null) {
      emit(File(image.path));
      // _image = File(image.path);
      
    }
  }


  // final ImagePicker _picker = ImagePicker();
  // // Pick an image using the camera
  // Future<void> pickImageFromCamera() async {
  //   final XFile? image = await _picker.pickImage(source: ImageSource.camera);
  //   if (image != null) {
  //     emit(File(image.path));
  //     // _image = File(image.path);
  //     
  //   }
  // }



  void clearImage() {
    emit(File(""));
  }
}
