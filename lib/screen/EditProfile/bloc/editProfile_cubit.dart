import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../apiServices/api_services.dart';
import '../model/editProfile_model.dart';
import 'editProfile_sate.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  final ApiService _apiService;

  EditProfileCubit(this._apiService) : super(EditProfileInitial());

  Future<void> editProfile(
      {required String token,
      required String firstName,
      required String lastName,
      required String email,
      required String customerId,
      File? profilePhoto}) async {
    emit(EditProfileLoading());
    try {
      final response = await _apiService.getUpdateProfile(
          token: token,
          email: email,
          customerId: customerId,
          profilePhoto: profilePhoto, firstName: firstName,lastName: lastName);

      if (response.data != null) {
        final editProfileResponse = EditProfileModel.fromJson(response.data);

        if (response.statusCode == 200) {
          emit(EditProfileSuccess(editProfileResponse));
        } else {
          emit(EditProfileFailure(editProfileResponse.message.toString()));
        }
      }
    } catch (e) {
      emit(EditProfileFailure('An error occurred: ${e.toString()}'));
    }
  }
}

class PickImageCubit extends Cubit<File> {
  PickImageCubit() : super(File(""));
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      emit(File((pickedFile.path)));
    }
  }

  void clear(){
    emit(File(""));
  }
}
