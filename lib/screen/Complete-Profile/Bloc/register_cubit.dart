import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_verify/screen/Complete-Profile/Bloc/register_state.dart';
import 'package:v_verify/screen/Complete-Profile/model/register_model.dart';

import '../../../apiServices/api_services.dart';

class RegisterCubit extends Cubit<RegisterState> {
  ApiService _apiService;

  RegisterCubit(this._apiService) : super(RegisterInitialState());

 Future<void> userRegister(
      {required String firstName,
      required String lastName,
      required String mobileNumber,
      required String email,
      required String userType,
       File? profilePhoto}) async {
    emit(RegisterLoading());
    try {
      final response = await _apiService.userRegister(
          firstName: firstName,
          lastName: lastName,
          mobileNumber: mobileNumber,
          email: email,
          userType: userType,
          profilePhoto: profilePhoto);

      if (response.data != null && response.data.containsKey("status")) {
        final status = response.data["status"];
        final RegisterModel registerModel =
            RegisterModel.fromJson(response.data);
        if (status == 200) {
          emit(RegisterSuccess(registerModel));
        } else if (status == 500) {
          final errorMessage =
              response.data['message'];
          emit(RegisterError(errorMessage));
        } else {
          emit(RegisterError('Login failed with status: $status'));
        }
      } else {
        emit(RegisterError('Invalid response data.'));
      }
    } catch (e) {
      emit(RegisterError('An error occurred: ${e.toString()}'));
    }
  }
}
