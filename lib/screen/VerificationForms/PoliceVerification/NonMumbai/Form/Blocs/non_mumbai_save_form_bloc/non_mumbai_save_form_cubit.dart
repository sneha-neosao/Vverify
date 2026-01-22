import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

import '../../../../../../../apiServices/api_services.dart';
import '../../Models/non_mumbai_police_save_form_model.dart';
import 'non_mumbai_save_form_state.dart';

class NonMumbaiTenantCompanyLetterImage extends Cubit<File> {
  NonMumbaiTenantCompanyLetterImage() : super(File(""));

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

  // Pick an image from the gallery
  // Future<void> pickImageFromGallery() async {
  //   final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  //   if (image != null) {
  //     emit(File(image.path));
  //     // _image = File(image.path);
  //     
  //   }
  // }

  // Pick an image using the camera
  Future<void> pickImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      emit(File(image.path));
      // _image = File(image.path);

    }
  }
  void clearImage(){
    emit(File(""));
  }
}

class NonMumbaiSignaturePhotoCubit extends Cubit<File> {
  NonMumbaiSignaturePhotoCubit() : super(File(""));

  final ImagePicker _picker = ImagePicker();



  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["pdf","png", "jpg", "jpeg"],
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
  void clearImage(){
    emit(File(""));
  }
}

class NonMumbaiPhotoCubit extends Cubit<File> {
  NonMumbaiPhotoCubit() : super(File(""));

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
  void clearImage(){
    emit(File(""));
  }
}

class NonMumbaiIdentityProof extends Cubit<File> {
  NonMumbaiIdentityProof() : super(File(""));



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

  final ImagePicker _picker = ImagePicker();
  // Pick an image using the camera
  Future<void> pickImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      emit(File(image.path));
      // _image = File(image.path);
      
    }
  }
  void clearImage(){
    emit(File(""));
  }
}



class NonMumbaiVerificationFormCubit extends Cubit<NonMumbaiVerificationState> {
  ApiService _apiService;

  NonMumbaiVerificationFormCubit(this._apiService)
      : super(NonMumbaiVerificationInitialState());

  void nonMumbaiVerificationForm(
      {
        required String token,
        required String customer_id,
        required NonMumbaiModel nonMumbaiModel}) async {
    emit(NonMumbaiVerificationLoadingState());
    try {
      final response = await _apiService.tenantNonMumbaiForm(
          customer_id: customer_id,
          token: token,
          nonMumbai: nonMumbaiModel);

      if (response.data != null && response.data.containsKey("status")) {
        if (response.data["status"] == 200) {
          emit(NonMumbaiVerificationSuccessState(response.data));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(NonMumbaiVerificationErrorState(errorMessage));
        } else {
          emit(NonMumbaiVerificationErrorState(
              'Profile failed with status: ${response.data["status"]}'));
        }
      } else {
        emit(NonMumbaiVerificationErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(NonMumbaiVerificationErrorState('An error occurred:$e'));
    }
  }
}

class EmployedCubit extends Cubit<bool> {
  EmployedCubit() : super(false);

  void employedYesNo({required bool yesNo}) {
    emit(yesNo);
  }

  void clear(){
    emit(false);
  }
}

class CriminalCubit extends Cubit<bool> {
  CriminalCubit() : super(false);

  void criminalYesNo({required bool yesNo}) {
    emit(yesNo);
  }

  void clear(){
    emit(false);
  }
}

class ArrestedCubit extends Cubit<bool> {
  ArrestedCubit() : super(false);

  void arrestedYesNo({required bool yesNo}) {
    emit(yesNo);
  }

  void clear(){
    emit(false);
  }
}

class FormUploadCubit extends Cubit<bool> {
  FormUploadCubit() : super(false);

  void formUploadYesNo({required bool yesNo}) {
    emit(yesNo);
  }

  void clear(){
    emit(false);
  }
}
