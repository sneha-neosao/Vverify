import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:v_verify/apiServices/api_services.dart';
import 'package:v_verify/screen/VerificationForms/VerifyDeatils/Model/verify_details_model.dart';
import 'package:v_verify/screen/VerificationPending/bloc/verify_report_bloc/verify_request_report_state.dart';
import 'dart:io';
import 'package:flutter_downloader/flutter_downloader.dart';


class VerifyRequestReportCubit extends Cubit<VerifyRequestReportState> {
  ApiService _apiService;

  VerifyRequestReportCubit(this._apiService) : super(VerifyRequestReportInitialState());

  Future<void> verifyRequestReport({  // <-- change here
    required String token,
    required String case_uuid,
  }) async {
    emit(VerifyRequestReportLoadingState());
    try {
      final response = await _apiService.VerifyRequestReportDownload(
        token: token,
        case_uuid: case_uuid,
      );

      if (response.data is List<int>) {
        final pdfBytes = response.data as List<int>;

        final downloadsDir = await getExternalStorageDirectory(); // safer than hardcoding
        final file = File('${downloadsDir!.path}/report_$case_uuid.pdf');
        await file.writeAsBytes(pdfBytes);

// Now open the file using FileProvider
//         OpenFilex.open(file.path); // use open_filex package

        emit(VerifyRequestReportDownloadedState(file.path));
      } else {
        emit(VerifyRequestReportErrorState('Unexpected response format.'));
      }
    } catch (e) {
      emit(VerifyRequestReportErrorState('An error occurred: $e'));
    }
  }
}

