import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_verify/screen/VerificationForms/PoliceVerification/Common/PoliceStationId/police_station_id_bloc/police_station_id_state.dart';
import '../../../../../../apiServices/api_services.dart';
import '../Models/police_station_city_id_model.dart';
import '../Models/police_station_id_model.dart';

class PoliceStationIdCubit extends Cubit<PoliceStationIdState> {
  ApiService _apiService;

  PoliceStationIdCubit(this._apiService) : super(PoliceStationIdInitialState());

  void policeStationList({
    required String token,
    required String city_id,
  }) async {
    emit(PoliceStationIdLoadingState());
    try {
      final response = await _apiService.policeStationIdGetData(
          token: token, city_id: city_id);
      if (response.data != null && response.data.containsKey("status")) {
        PoliceStationIdModel policeStationIdModel =
            PoliceStationIdModel.fromJson(response.data);
        if (response.data["status"] == 200) {
          emit(PoliceStationIdSuccessState(policeStationIdModel));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(PoliceStationIdErrorState(errorMessage));
        } else {
          emit(PoliceStationIdErrorState('${response.data["message"]}'));
        }
      } else {
        emit(PoliceStationIdErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(PoliceStationIdErrorState('An error occurred:$e'));
    }
  }
}

class PoliceStationCityIdCubit extends Cubit<PoliceStationCityIdState> {
  ApiService _apiService;

  PoliceStationCityIdCubit(this._apiService)
      : super(PoliceStationCityIdInitialState());

  void policeStationCityList({
    required String token,
  }) async {
    emit(PoliceStationCityIdLoadingState());
    try {
      final response = await _apiService.policeStationCityId(
        token: token,
      );
      if (response.data != null && response.data.containsKey("status")) {
        PoliceStationCityIdModel policeStationCityIdModel =
            PoliceStationCityIdModel.fromJson(response.data);
        if (response.data["status"] == 200) {
          emit(PoliceStationCityIdSuccessState(policeStationCityIdModel));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(PoliceStationCityIdErrorState(errorMessage));
        } else {
          emit(PoliceStationCityIdErrorState('${response.data["message"]}'));
        }
      } else {
        emit(PoliceStationCityIdErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(PoliceStationCityIdErrorState('An error occurred:$e'));
    }
  }
}
