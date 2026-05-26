import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:v_verify/apiServices/api_services.dart';
import 'package:v_verify/screen/ProfileScreen/bloc/sign_out_state.dart';

class SignOutCubit extends Cubit<SignOutState> {
  final ApiService _apiService;

  SignOutCubit(this._apiService) : super(SignOutInitial());

  void signOut({required String token, required String customerId}) async {
    emit(SignOutLoading());
    try {
      await _apiService.logout(token: token, customerId: customerId);
      
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('id');
      await prefs.remove('userType');
      await prefs.remove('token');
      
      emit(SignOutSuccess());
    } catch (e) {
      // Resilient fallback: even if the API request fails (e.g. offline or expired token), 
      // we still clear local storage so the user isn't stuck.
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('id');
      await prefs.remove('userType');
      await prefs.remove('token');
      
      emit(SignOutSuccess());
    }
  }
}
