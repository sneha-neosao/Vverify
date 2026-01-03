import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../apiServices/api_services.dart';
import '../model/mumbai_model.dart';
import 'mumbaiPolice_verification_state.dart';

class PropertyOwnersProfileImage extends Cubit<File> {
  PropertyOwnersProfileImage() : super(File(""));

  final ImagePicker _picker = ImagePicker();

  //Pick an image from the gallery
  Future<void> pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      emit(File(image.path));
      // _image = File(image.path);
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

class TenantPhotoProfileImage extends Cubit<File> {
  TenantPhotoProfileImage() : super(File(""));

  final ImagePicker _picker = ImagePicker();

  //Pick an image from the gallery
  Future<void> pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      emit(File(image.path));
      // _image = File(image.path);
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

class TenantIdentityProofImage extends Cubit<File> {
  TenantIdentityProofImage() : super(File(""));

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

class TenantCompanyLetterImage extends Cubit<File> {
  TenantCompanyLetterImage() : super(File(""));

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

class MumbaiVerificationFormCubit extends Cubit<MumbaiVerificationState> {
  ApiService _apiService;

  MumbaiVerificationFormCubit(this._apiService)
      : super(MumbaiVerificationInitialState());

  void nonMumbaiVerificationForm(
      {required String token,
      required String customerId,
      required MumbaiModel mumbaiModel}) async {
    emit(MumbaiVerificationLoadingState());
    try {
      final response = await _apiService.tenantMumbaiForm(
          customerId: customerId, token: token, mumbaiModel: mumbaiModel);

      if (response.data != null && response.data.containsKey("status")) {
        if (response.data["status"] == 200) {
          emit(MumbaiVerificationSuccessState(response.data));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(MumbaiVerificationErrorState(errorMessage));
        } else {
          emit(MumbaiVerificationErrorState(
              'Profile failed with status: ${response.data["status"]}'));
        }
      } else {
        emit(MumbaiVerificationErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(MumbaiVerificationErrorState('An error occurred:$e'));
    }
  }
}

class FormUploadMumbaiCubit extends Cubit<bool> {
  FormUploadMumbaiCubit() : super(false);

  void formUploadYesNo({required bool yesNo}) {
    emit(yesNo);
  }
}
