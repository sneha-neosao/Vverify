import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../../apiServices/api_services.dart';
import '../../Model/education_save_form_model.dart';
import 'education_save_form_state.dart';

class EducationSaveFormCubit extends Cubit<EducationSaveFormState> {
  final ApiService _apiService;

  EducationSaveFormCubit(this._apiService)
      : super(EducationSaveFormInitialState());

  void educationSaveForm(
      {required String customer_id,
      required String token,
      required EducationSaveFormModel educationSaveFormModel}) async {
    emit(EducationSaveFormLoadingState());
    try {
      final response = await _apiService.EducationFormSave(
        customer_id: customer_id,
        token: token,
        educationSaveFormModel: educationSaveFormModel,
      );
      if (response.data != null && response.data.containsKey("status")) {
        if (response.data["status"] == 200) {
          emit(EducationSaveFormSuccessState(response.data));
        } else if (response.data["status"] == 500) {
          final errorMessage = response.data['message'];
          emit(EducationSaveFormErrorState(errorMessage));
        } else {
          emit(EducationSaveFormErrorState('${response.data["message"]}'));
        }
      } else {
        emit(EducationSaveFormErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(EducationSaveFormErrorState('An error occurred:$e'));
    }
  }
}

class EducationCertificateDocuments extends Cubit<File> {
  EducationCertificateDocuments() : super(File(""));

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

class FormUploadEducationtCubit extends Cubit<bool> {
  FormUploadEducationtCubit() : super(false);

  void formUploadYesNo({required bool yesNo}) {
    emit(yesNo);
  }
}
