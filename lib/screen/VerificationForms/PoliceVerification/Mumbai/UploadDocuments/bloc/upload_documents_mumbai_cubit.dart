import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:v_verify/screen/VerificationForms/PoliceVerification/Mumbai/UploadDocuments/bloc/upload_documents_mumbai_state.dart';

import '../../../../../../apiServices/api_services.dart';
import '../Model/upload_documents_mumbai.dart';

class UploadDocumentMumbaiOwnerPhoto extends Cubit<File> {
  UploadDocumentMumbaiOwnerPhoto() : super(File(""));

  final ImagePicker _picker = ImagePicker();

  // Pick an image from the gallery
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

class UploadDocumentMumbaiTenantPhoto extends Cubit<File> {
  UploadDocumentMumbaiTenantPhoto() : super(File(""));

  final ImagePicker _picker = ImagePicker();

  // Pick an image from the gallery
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

class UploadDocumentMumbaiTenantIdentityProof extends Cubit<File> {
  UploadDocumentMumbaiTenantIdentityProof() : super(File(""));

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

class UploadDocumentMumbaiTenantSignature extends Cubit<File> {
  UploadDocumentMumbaiTenantSignature() : super(File(""));

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

  Future<void> captureAndSaveImage({required GlobalKey repaintKey}) async {
    try {
      RenderRepaintBoundary boundary = repaintKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage();
      var byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      var buffer = byteData!.buffer.asUint8List();

      // Save the image to a file
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/drawing.png');
      await file.writeAsBytes(buffer);

      emit(File(file.path));
      print('Image saved to ${file.path}');
    } catch (e) {
      print("Error saving image: $e");
    }
  }

  Future<void> addSignature(context, _signaturePadKey) async {

    String getRandomString(int length) {
      const characters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
      final random = Random();
      return String.fromCharCodes(Iterable.generate(
        length,
            (_) => characters.codeUnitAt(random.nextInt(characters.length)),
      ));
    }
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 100,
          child: AlertDialog(
            backgroundColor: Theme.of(context).cardColor,
            title: Text(
              'Add Signature',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            content: SizedBox(
              height: 300,
              width: double.infinity,
              child: SfSignaturePad(
                key: _signaturePadKey,
                minimumStrokeWidth: 1,
                maximumStrokeWidth: 3,
                strokeColor: Colors.black,
                backgroundColor: Colors.grey,
              ),
            ),
            actions: <Widget>[

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                        textStyle: Theme.of(context).textTheme.labelLarge),
                    child: Text(
                      'Clear',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    onPressed: () async {
                      _signaturePadKey.currentState!.clear();
                    },
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                        textStyle: Theme.of(context).textTheme.labelLarge),
                    child: Text(
                      'Add Signature',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    onPressed: () async {
                      final data = await _signaturePadKey.currentState!.toImage();
                      final bytes =
                          await data.toByteData(format: ui.ImageByteFormat.png);
                      var buffer = bytes!.buffer.asUint8List();
                      // _signatureImage = bytes!.buffer.asUint8List();

                      final directory = await getApplicationDocumentsDirectory();
                      final file = File('${directory.path}/${getRandomString(5)}.png');
                      await file.writeAsBytes(buffer).then((_) {
                        emit(file);

                      });
                      context.pop();
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void clearImage() {
    emit(File(""));
  }
}

// class UploadDocumentMumbaiTenantSignatureDraw extends Cubit<File> {
//   UploadDocumentMumbaiTenantSignatureDraw() : super(File(""));
//
//   void addSignature(signaturePadKey) async {
//     final data = await signaturePadKey.currentState!.toImage();
//     final bytes = await data.toByteData(format: ui.ImageByteFormat.png);
//     var buffer = bytes!.buffer.asUint8List();
//     // _signatureImage = bytes!.buffer.asUint8List();
//
//     final directory = await getApplicationDocumentsDirectory();
//     final file = File('${directory.path}/drawing.png');
//     await file.writeAsBytes(buffer);
//
//     emit(file);
//   }
// }

class UploadDocumentMumbai extends Cubit<File> {
  UploadDocumentMumbai() : super(File(""));

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

class UploadDocumentsMumbaiCubit extends Cubit<UploadDocumentMumbaiState> {
  ApiService _apiService;

  UploadDocumentsMumbaiCubit(this._apiService)
      : super(UploadDocumentMumbaiInitialState());

  void uploadDocumentsMumbai(
      {
        required String token,
        required String customer_id,
      required UploadDocumentsMumbaiModel uploadDocumentsMumbaiModel}) async {
    emit(UploadDocumentMumbaiLoadingState());
    try {
      final response = await _apiService.tenantMumbaiUploadDocuments(
          customer_id: customer_id,
          token: token,
          uploadDocumentsMumbaiModel: uploadDocumentsMumbaiModel);

      if (response.data != null && response.data.containsKey("status")) {
        if (response.data["status"] == 200) {
          emit(UploadDocumentMumbaiSuccessState(response.data));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(UploadDocumentMumbaiErrorState(errorMessage));
        } else {
          emit(UploadDocumentMumbaiErrorState(
              'uploadDocuments failed with status: ${response.data["status"]}'));
        }
      } else {
        emit(UploadDocumentMumbaiErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(UploadDocumentMumbaiErrorState('An error occurred:$e'));
    }
  }
}
