import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:v_verify/screen/VerificationForms/EmploymentVerification/Documents/Blocs/employment_document_upload_bloc/employment_document_upload_state.dart';
import '../../../../../../apiServices/api_services.dart';

class EmploymentUploadCubit extends Cubit<EmploymentUploadState> {
  ApiService _apiService;

  EmploymentUploadCubit(this._apiService)
      : super(EmploymentUploadInitialState());

  void employmentUpload({
    required String token,
    required String caseUuid,
    required List<File> documents,
  }) async {
    emit(EmploymentUploadLoadingState());
    try {
      final response = await _apiService.EmploymentDocsUpload(
        token: token,
        caseUuid: caseUuid,
        documents: documents,
      );
      if (response.data != null && response.data.containsKey("status")) {
        if (response.data["status"] == 200) {
          emit(EmploymentUploadSuccessState(response.data));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(EmploymentUploadErrorState(errorMessage));
        } else {
          emit(EmploymentUploadErrorState('${response.data["message"]}'));
        }
      } else {
        emit(EmploymentUploadErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(EmploymentUploadErrorState('An error occurred:$e'));
    }
  }
}

class EmploymentDocsFileCubit extends Cubit<List<File>> {
  EmploymentDocsFileCubit() : super([]);

  final ImagePicker _picker = ImagePicker();

  /// Pick multiple files (pdf, png, jpg, jpeg)
  Future<void> pickMultipleFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
    );
    if (result != null) {
      final files = result.paths.whereType<String>().map((path) => File(path)).toList();
      emit([...state, ...files]); // append to existing state
    }
  }

  /// Pick an image using the camera
  Future<void> pickImageFromCamera() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );
    if (image != null) {
      emit([...state, File(image.path)]);
    }
  }

  /// Clear all selected files
  void clearFiles() {
    emit([]);
  }

  /// Remove a single file by index
  void removeFileAt(int index) {
    final updated = List<File>.from(state)..removeAt(index);
    emit(updated);
  }
}
