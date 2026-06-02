import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_verify/apiServices/api_services.dart';
import '../../Models/driving_licence_save_model.dart';
import 'driving_licence_save_form_state.dart';

class DrivingLicenceBloc extends Cubit<DrivingLicenceState> {
  final ApiService _apiService;

  DrivingLicenceBloc(this._apiService) : super(DrivingLicenceInitialState());

  void drivingLicenceSaveData({
    required String token,
    required String customer_id,
    required String request_id,
    required String service_request_id,
    required String service_id,
    required String document_type,
    required String driver_licence_number,
    required String dob,
    required File? document_scan_pdf,
    String? status,
  }) async {
    emit(DrivingLicenceLoadingState());
    try {
      final response = await _apiService.drivingLicenceSave(
        customer_id: customer_id,
        token: token,
        request_id: request_id,
        service_request_id: service_request_id,
        service_id: service_id,
        document_type: document_type,
        document_number: driver_licence_number,
        dob: dob,
        document_scan_pdf: document_scan_pdf,
      );

      if (response.data != null) {
        final saveModel = DrivingLicenceSaveModel.fromJson(response.data);
        if (saveModel.status == 200) {
          emit(DrivingLicenceSuccessState(saveModel));
        } else if (saveModel.status == 500) {
          final errorMessage = saveModel.message ?? 'Unknown error occurred.';
          emit(DrivingLicenceErrorState(errorMessage));
        } else {
          emit(DrivingLicenceErrorState('${saveModel.message}'));
        }
      } else {
        emit(DrivingLicenceErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(DrivingLicenceErrorState('An error occurred:$e'));
    }
  }
}

class FormUploadDrivingCubit extends Cubit<bool> {
  FormUploadDrivingCubit() : super(false);

  void formUploadYesNo({required bool yesNo}) {
    emit(yesNo);
  }
}
