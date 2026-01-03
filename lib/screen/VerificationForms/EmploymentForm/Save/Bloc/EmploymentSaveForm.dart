import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../apiServices/api_services.dart';
import '../Model/employmentSaveForm_model.dart';
import 'EmploymentSaveFormState.dart';

class EmploymentLetterImage extends Cubit<File> {
  EmploymentLetterImage() : super(File(""));

  final ImagePicker _picker = ImagePicker();


  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      compressionQuality: 50,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);

      emit(file);
    } else {
      // User canceled the picker
    }
  }

  // Pick an image using the camera
  Future<void> pickImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera,imageQuality: 50);
    if (image != null) {
      emit(File(image.path));
      // _image = File(image.path);
      
    }
  }

  void clearImage() {
    emit(File(""));
  }
}

class EmploymentSupportDocument extends Cubit<File> {
  EmploymentSupportDocument() : super(File(""));

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);

      emit(file);
    } else {
      // User canceled the picker
    }
  }

  final ImagePicker _picker = ImagePicker();

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

class EmploymentMarkSheetDocument extends Cubit<File> {
  EmploymentMarkSheetDocument() : super(File(""));

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);

      emit(file);
      print("pdfFile${result.files.single.name}");
      print("pdfFile${result.files.single.path!}");
    } else {
      // User canceled the picker
    }
  }

  final ImagePicker _picker = ImagePicker();

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

class EmploymentSupportDocumentImage extends Cubit<File> {
  EmploymentSupportDocumentImage() : super(File(""));

  final ImagePicker _picker = ImagePicker();

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);

      emit(file);
    } else {
      // User canceled the picker
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

class ExperienceDocumentImage extends Cubit<File> {
  ExperienceDocumentImage() : super(File(""));

  final ImagePicker _picker = ImagePicker();

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);

      emit(file);
    } else {
      // User canceled the picker
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

class RelivingLetterDocumentImage extends Cubit<File> {
  RelivingLetterDocumentImage() : super(File(""));

  final ImagePicker _picker = ImagePicker();

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);

      emit(file);
    } else {
      // User canceled the picker
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



class FormUploadEmploymentCubit extends Cubit<bool> {
  FormUploadEmploymentCubit() : super(false);

  void formUploadYesNo({required bool yesNo}) {
    emit(yesNo);
  }
}

class EmploymentSaveFormCubit extends Cubit<EmploymentSaveFormState> {
  ApiService _apiService;

  EmploymentSaveFormCubit(this._apiService)
      : super(EmploymentSaveFormInitialState());

  void employmentSaveForm(
      {
        required String token,
        required String customer_id,
      required EmploymentSaveFormModel employmentSaveFormModel}) async {
    emit(EmploymentSaveFormLoadingState());
    try {
      final response = await _apiService.EmploymentSaveForm(
          token: token,
          customer_id: customer_id,
          employmentSaveFormModel: employmentSaveFormModel);
      if (response.data != null && response.data.containsKey("status")) {
        if (response.data["status"] == 200) {
          emit(EmploymentSaveFormSuccessState(response.data));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(EmploymentSaveFormErrorState(errorMessage));
        } else {
          emit(EmploymentSaveFormErrorState('${response.data["message"]}'));
        }
      } else {
        emit(EmploymentSaveFormErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(EmploymentSaveFormErrorState('An error occurred:$e'));
    }
  }
}
