import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_verify/apiServices/api_services.dart';
import 'package:v_verify/screen/Home%20screen/bloc/home_screen_state.dart';
import 'package:v_verify/screen/Home%20screen/model/home_Screen_model.dart';

class HomeScreenCubit extends Cubit<HomeScreenState> {
  ApiService _apiService;

  HomeScreenCubit(this._apiService) : super(HomeScreenInitialState());

  void getEntity({required String token}) async {
    final currentState = state;

    if (state is HomeScreenLoadingState) return;
    try {
      emit(HomeScreenLoadingState());
      final response = await _apiService.getEntity(token: token);

      if (response.data != null && response.data.containsKey("status")) {
        final HomeScreenModel homeScreenModel =
            HomeScreenModel.fromJson(response.data);
        if (homeScreenModel.status == 200) {
          if (currentState is! HomeScreenSuccessState ||
              currentState.homeScreenModel != response.data) {
            emit(HomeScreenSuccessState(homeScreenModel));
          }
        } else if (homeScreenModel.status == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(HomeScreenErrorState(errorMessage));
        } else {
          emit(HomeScreenErrorState(
              '${homeScreenModel.status} \n ${homeScreenModel.message}'));
        }
      } else {
        emit(HomeScreenErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(HomeScreenErrorState('An error occurred:$e'));
    }
  }
}

class CountCubit extends Cubit<int> {
  CountCubit() : super(1);

  void countAdd() {
    emit(state + 1);
  }

  void countRemove() {
    if (state != 1) {
      emit(state - 1);
    }
  }

  void clear() {
    emit(1);
  }
}

class UserTermsConditionCubit extends Cubit<UserTermsConditionState> {
  ApiService _apiService;

  UserTermsConditionCubit(this._apiService)
      : super(UserTermsConditionInitialState());

  void termsCondition({
    required String token,
    required String customer_id,
    required String flag,
  }) async {
    emit(UserTermsConditionLoadingState());
    try {
      final response = await _apiService.userAgreeCondition(
        token: token,
        customer_id: customer_id,
        flag: flag,
      );

      if (response.data != null && response.data.containsKey("status")) {
        if (response.data["status"] == 200) {
          emit(UserTermsConditionSuccessState(response.data));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(UserTermsConditionErrorState(errorMessage));
        } else {
          emit(UserTermsConditionErrorState(
              '${response.data["status"]} \n ${response.data["message"]}'));
        }
      } else {
        emit(UserTermsConditionErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(UserTermsConditionErrorState('An error occurred:$e'));
    }
  }
}


class AgreeCheck extends Cubit<bool>{
  AgreeCheck():super(false);

  void toggleCheckbox(value) {

      emit(value);

  }

}