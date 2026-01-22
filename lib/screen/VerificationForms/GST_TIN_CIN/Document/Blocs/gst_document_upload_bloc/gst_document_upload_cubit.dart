import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:v_verify/apiServices/api_services.dart';

import 'gst_document_upload_state.dart';

class GstPanCinDocUploadCubit extends Cubit<GstPanCinDocUploadState> {
  ApiService _apiService;

  GstPanCinDocUploadCubit(this._apiService)
      : super(GstPanCinDocUploadInitialState());

  void gstPanCinDocUpload({
    required String customer_id,
    required String token,
    required String request_id,
    required String service_request_id,
    required File gst_document,
    required File pan_document,
    required File cin_document,
  }) async {
    emit(GstPanCinDocUploadLoadingState());
    try {
      final response = await _apiService.gstPanCinDocUpload(
        customer_id: customer_id,
        token: token,
        request_id: request_id,
        service_request_id: service_request_id,
        gst_document: gst_document,
        pan_document: pan_document,
        cin_document: cin_document,
      );

      if (response.data != null && response.data.containsKey("status")) {
        if (response.data["status"] == 200) {
          emit(GstPanCinDocUploadSuccessState(response.data));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(GstPanCinDocUploadErrorState(errorMessage));
        } else {
          emit(GstPanCinDocUploadErrorState('${response.data["message"]}'));
        }
      } else {
        emit(GstPanCinDocUploadErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(GstPanCinDocUploadErrorState('An error occurred:$e'));
    }
  }
}

class PanDocUpload extends Cubit<File> {
  PanDocUpload() : super(File(""));

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

class GstDocUpload extends Cubit<File> {
  GstDocUpload() : super(File(""));

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

class CinDocUpload extends Cubit<File> {
  CinDocUpload() : super(File(""));

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
