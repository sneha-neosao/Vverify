import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:v_verify/screen/VerificationForms/AddressVerificationForm/Documents/Blocs/address_document_upload_bloc/address_document_upload_state.dart';
import '../../../../../../apiServices/api_services.dart';

class AddressDocsUploadCubitNew extends Cubit<AddressDocUploadStateNew> {
  final ApiService _apiService;

  AddressDocsUploadCubitNew(this._apiService)
      : super(AddressDocUploadInitialStateNew());

  Future<void> uploadAddressDocs({
    required String token,
    required String caseUuid,
    required List<File> documents,
  }) async {
    emit(AddressDocUploadLoadingStateNew());
    try {
      final response = await _apiService.AddressDocsUpload(
        token: token,
        caseUuid: caseUuid,
        documents: documents,
      );

      if (response.data != null && response.data.containsKey("status")) {
        final status = response.data["status"];
        if (status == 200) {
          emit(AddressDocUploadSuccessStateNew(response.data));
        } else {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(AddressDocUploadErrorStateNew(errorMessage));
        }
      } else {
        emit(AddressDocUploadErrorStateNew('Invalid response data.'));
      }
    } catch (e) {
      emit(AddressDocUploadErrorStateNew('An error occurred: $e'));
    }
  }
}

class AddressDocsFileCubit extends Cubit<List<File>> {
  AddressDocsFileCubit() : super([]);

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
