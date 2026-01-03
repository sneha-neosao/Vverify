import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_verify/screen/Login-Screen/bloc/login_state.dart';
import 'package:v_verify/screen/Login-Screen/model/login_model.dart';

import '../../../apiServices/api_services.dart';

class LoginCubit extends Cubit<LoginState> {
  ApiService _apiService;

  LoginCubit(this._apiService) : super(loginInitialState());

  void Login({required String mobileNumber}) async {
    emit(LoginLoading());
    try {
      final response =
          await _apiService.loginWithMobileNumber(mobileNumber: mobileNumber);
      if (response.data != null && response.data.containsKey("status")) {
        final LoginModel loginModel = LoginModel.fromJson(response.data);
       // final status = response.data["status"];
        emit(LoginSuccess(loginModel));
      } else {
        emit(LoginError('Invalid response data.'));
      }
    } catch (e) {
      emit(LoginError('An error occurred: ${e.toString()}'));
    }
  }
}
