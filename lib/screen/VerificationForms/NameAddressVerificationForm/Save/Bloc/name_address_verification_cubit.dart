import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../apiServices/api_services.dart';
import '../model/name_address_verification_model.dart';
import 'name_address_verification_state.dart';

class NameAddressAadhaarFrontSideCubit extends Cubit<File> {
  NameAddressAadhaarFrontSideCubit() : super(File(""));

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

class NameAddressAadhaarBackSideCubit extends Cubit<File> {
  NameAddressAadhaarBackSideCubit() : super(File(""));

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

class NameAddressVerificationFormCubit
    extends Cubit<NameAddressVerificationState> {
  ApiService _apiService;

  NameAddressVerificationFormCubit(this._apiService)
      : super(NameAddressVerificationInitialState());

  void nameAddressForm(
      {required String token,
      required String customer_id,
      required NameAddressVerificationModel
          nameAddressVerificationModel}) async {
    emit(NameAddressVerificationLoadingState());
    try {
      final response = await _apiService.NameAddressStore(
          customer_id: customer_id,
          token: token,
          nameAddressVerificationModel: nameAddressVerificationModel);

      if (response.data != null && response.data.containsKey("status")) {
        if (response.data["status"] == 200) {
          emit(NameAddressVerificationSuccessState(response.data));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(NameAddressVerificationErrorState(errorMessage));
        } else {
          emit(NameAddressVerificationErrorState(
              '${response.data["status"]} \n ${response.data["message"]}'));
        }
      } else {
        emit(NameAddressVerificationErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(NameAddressVerificationErrorState('An error occurred:$e'));
    }
  }
}

class FormUploadNameAddressCubit extends Cubit<bool> {
  FormUploadNameAddressCubit() : super(false);

  void formUploadYesNo({required bool yesNo}) {
    emit(yesNo);
  }
}
