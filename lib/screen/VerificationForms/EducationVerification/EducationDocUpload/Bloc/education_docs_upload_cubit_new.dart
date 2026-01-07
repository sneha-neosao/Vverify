import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../apiServices/api_services.dart';
import 'education_docs_upload_state_new.dart';

class EducationDocsUploadCubitNew extends Cubit<EducationDocUploadStateNew> {
  final ApiService _apiService;

  EducationDocsUploadCubitNew(this._apiService)
      : super(EducationDocUploadInitialStateNew());

  Future<void> uploadEducationDocs({
    required String token,
    required String caseUuid,
    required List<File> documents,
  }) async {
    emit(EducationDocUploadLoadingStateNew());
    try {
      final response = await _apiService.EducationDocsUpload(
        token: token,
        caseUuid: caseUuid,
        documents: documents,
      );

      if (response.data != null && response.data.containsKey("status")) {
        final status = response.data["status"];
        if (status == 200) {
          emit(EducationDocUploadSuccessStateNew(response.data));
        } else {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(EducationDocUploadErrorStateNew(errorMessage));
        }
      } else {
        emit(EducationDocUploadErrorStateNew('Invalid response data.'));
      }
    } catch (e) {
      emit(EducationDocUploadErrorStateNew('An error occurred: $e'));
    }
  }
}

class EducationDocsFileCubit extends Cubit<List<File>> {
  EducationDocsFileCubit() : super([]);

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
