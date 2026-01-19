import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pinput/pinput.dart';

import '../../../../../../apiServices/api_services.dart';
import 'court_verification_update_form_state.dart';

class CourtUpdateCubit extends Cubit<CourtUpdateState> {
  ApiService _apiService;

  CourtUpdateCubit(this._apiService) : super(CourtUpdateInitialState());

  void courtVerificationUpdateForm({
    required String customer_id,
    required String token,
    required String request_id,
    required String serviceRequestId,
    required String first_name,
    required String last_name,
    required String father_name,
    required String dob,
    required String address,
  }) async {
    emit(CourtUpdateLoadingState());
    try {
      final response = await _apiService.courtVerificationUpdate(
        customer_id: customer_id,
        token: token,
        request_id: request_id,
        service_request_id: serviceRequestId,
        first_name: first_name,
        last_name: last_name,
        father_name: father_name,
        dob: dob,
        address: address,
      );
      if (response.data != null && response.data.containsKey("status")) {
        if (response.data["status"] == 200) {
          emit(CourtUpdateSuccessState(response.data));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(CourtUpdateErrorState(errorMessage));
        } else {
          emit(CourtUpdateErrorState(
              '${response.data["status"]} \n ${response.data["message"]}'));
        }
      } else {
        emit(CourtUpdateErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(CourtUpdateErrorState('An error occurred:$e'));
    }
  }
}

class UpdateDateCubit extends Cubit<String> {
  UpdateDateCubit() : super("");

  DateTime selectedJoiningDate = DateTime.now();
  TextEditingController birthDateControllerC = TextEditingController();


  Future<void> selectJoiningDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedJoiningDate, // initial date
      firstDate: DateTime(1900), // the earliest possible date
      lastDate: DateTime(2101), // the latest possible date
    );
    if (picked != null && picked != selectedJoiningDate) {
      String formattedDate = DateFormat('MM/dd/yyyy').format(picked);

      selectedJoiningDate = picked;
      birthDateControllerC.setText(formattedDate);
      emit(formattedDate);

      // birthDateController.text = formattedDate;
      //birthDateController.setText(formattedDate);
    }
  }
}
