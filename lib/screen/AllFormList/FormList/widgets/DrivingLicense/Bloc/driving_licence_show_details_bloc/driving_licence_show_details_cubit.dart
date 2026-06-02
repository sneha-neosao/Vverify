import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_verify/apiServices/api_services.dart';

import '../../Models/driving_licence_show_details_model.dart';
import 'driving_licence_show_details_state.dart';

class DrivingLicenceShowDataCubit extends Cubit<DrivingLicenceShowDataState> {
  final ApiService _apiService;

  DrivingLicenceShowDataCubit(this._apiService)
      : super(DrivingLicenceShowDataInitialState());

  void drivingLicenceShowDataLoad(
      {required String token, required String uid}) async {
    emit(DrivingLicenceShowDataLoadingState());
    try {
      final response = await _apiService.drivingLicenceShowData(
        token: token,
        uid: uid,
      );
      if (response.data != null && response.data.containsKey("status")) {
        DrivingLicenceShowDataModel drivingLicenceShowDataModel =
            DrivingLicenceShowDataModel.fromJson(response.data);
        if (response.data["status"] == 200) {
          emit(DrivingLicenceShowDataSuccessState(drivingLicenceShowDataModel));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(DrivingLicenceShowDataErrorState(errorMessage));
        } else {
          emit(DrivingLicenceShowDataErrorState('${response.data["message"]}'));
        }
      } else {
        emit(DrivingLicenceShowDataErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(DrivingLicenceShowDataErrorState('An error occurred:$e'));
    }
  }
}
