import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_verify/apiServices/api_services.dart';
import 'package:v_verify/screen/ProfileScreen/bloc/profile_state.dart';
import 'package:v_verify/screen/ProfileScreen/model/profile_model.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ApiService _apiService;

  ProfileCubit(this._apiService) : super(ProfileInitialState());

  void getProfile({required String token, required String id}) async {
    emit(ProfileLoading());
    try {
      final response = await _apiService.getProfile(token: token, id: id);

      if (response.data != null && response.data.containsKey("status")) {
        final ProfileModel profileModel = ProfileModel.fromJson(response.data);
        final status = response.data["status"];
        if (status == 200) {
          emit(ProfileSuccess(profileModel));
        } else if (status == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(ProfileError(errorMessage));
        } else {
          emit(ProfileError('Profile failed with status: $status'));
        }
      } else {
        emit(ProfileError('Invalid response data.'));
      }
    } catch (e) {
      emit(ProfileError('An error occurred: ${e.toString()}'));
    }
  }
}
