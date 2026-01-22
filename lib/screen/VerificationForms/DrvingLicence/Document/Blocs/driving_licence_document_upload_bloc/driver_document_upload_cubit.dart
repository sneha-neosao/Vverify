import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:v_verify/apiServices/api_services.dart';
import 'driver_document_upload_state.dart';

class DriverDocUploadCubit extends Cubit<DriverDocUploadState> {
  ApiService _apiService;

  DriverDocUploadCubit(this._apiService)
      : super(DriverDocUploadInitialState());

  void drivingLicenceDocUploadData(
      {
        required String token,
        required String customer_id,
        required String request_id,
        required String service_request_id,
        required File data_document,
      }) async {
    emit(DriverDocUploadLoadingState());
    try {
      final response = await _apiService.drivingDocUpload(
        customer_id: customer_id,
        token: token,
        request_id: request_id,
        service_request_id: service_request_id,
      data_document: data_document,
      );

      if (response.data != null && response.data.containsKey("status")) {
        if (response.data["status"] == 200) {
          emit(DriverDocUploadSuccessState(response.data));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(DriverDocUploadErrorState(errorMessage));
        } else {
          emit(DriverDocUploadErrorState('${response.data["message"]}'));
        }
      } else {
        emit(DriverDocUploadErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(DriverDocUploadErrorState('An error occurred:$e'));
    }
  }
}

class DriverDocFileUpload extends Cubit<File> {
  DriverDocFileUpload() : super(File(""));

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
