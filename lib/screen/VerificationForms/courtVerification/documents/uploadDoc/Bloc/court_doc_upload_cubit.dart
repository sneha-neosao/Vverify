import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../apiServices/api_services.dart';
import 'court_doc_upload_state.dart';

class CourtDocUploadCubit extends Cubit<CourtDocUploadState> {
  ApiService _apiService;

  CourtDocUploadCubit(this._apiService) : super(CourtDocUploadInitialState());

  void courtVerificationDocumentUpload({
    required String token,
    required String customer_id,
    required String request_id,
    required String serviceRequestId,
    required File aadhaar_document,
    required File pan_document,
  }) async {
    emit(CourtDocUploadLoadingState());
    try {
      final response = await _apiService.courtVerificationDocUpload(
        customer_id: customer_id,
        token: token,
        request_id: request_id,
        service_request_id: serviceRequestId,
        aadhaar_document: aadhaar_document,
        pan_document: pan_document,
      );

      if (response.data != null && response.data.containsKey("status")) {
        if (response.data["status"] == 200) {
          emit(CourtDocUploadSuccessState(response.data));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(CourtDocUploadErrorState(errorMessage));
        } else {
          emit(CourtDocUploadErrorState(
              '${response.data["status"]} \n ${response.data["message"]}'));
        }
      } else {
        emit(CourtDocUploadErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(CourtDocUploadErrorState('An error occurred:$e'));
    }
  }
}

class CourtAadhaarUpload extends Cubit<File> {
  CourtAadhaarUpload() : super(File(""));

  final ImagePicker _picker = ImagePicker();

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

  // Pick an image using the camera
  Future<void> pickImageFromCamera() async {
    final XFile? image =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    if (image != null) {
      emit(File(image.path));
      // _image = File(image.path);
    }
  }

  /// Clears the image and deletes it if it came from the camera (cache folder)
  Future<void> clearImage() async {
    final currentFile = state;

    if (currentFile != null) {
      try {
        // Delete only if it's a temporary file (in cache)
        if (currentFile.path.contains('/cache/')) {
          if (await currentFile.exists()) {
            await currentFile.delete();
            print("Temporary camera image deleted: ${currentFile.path}");
          }
        }
      } catch (e) {
        print("Error deleting image: $e");
      }
    }

    // Reset the Cubit state
    emit(File(""));
  }

  @override
  Future<void> close() async {
    try {
      await clearImage();
    } catch (e) {
      print("Error during Cubit cleanup: $e");
    }
    return super.close();
  }
}

class CourtPanUpload extends Cubit<File> {
  CourtPanUpload() : super(File(""));

  final ImagePicker _picker = ImagePicker();

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

  // Pick an image using the camera
  Future<void> pickImageFromCamera() async {
    final XFile? image =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    if (image != null) {
      emit(File(image.path));
      // _image = File(image.path);
    }
  }

  void clearImage() {
    emit(File(""));
  }
}
