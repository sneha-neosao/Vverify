import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:v_verify/apiServices/api_services.dart';
import 'package:v_verify/screen/VerificationPending/bloc/verify_report_bloc/verify_request_report_state.dart';

class VerifyRequestReportCubit extends Cubit<VerifyRequestReportState> {
  final ApiService _apiService;

  VerifyRequestReportCubit(this._apiService)
      : super(VerifyRequestReportInitialState());

  Future<void> verifyRequestReport({
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

        // 1. Write to a temporary file
        final tempDir = await getTemporaryDirectory();
        final tempFilePath = '${tempDir.path}/report_$case_uuid.pdf';
        final tempFile = File(tempFilePath);
        await tempFile.writeAsBytes(pdfBytes);

        // 2. Initialize MediaStore and save to Downloads
        await MediaStore.ensureInitialized();
        MediaStore.appFolder = "vverify";

        final result = await MediaStore().saveFile(
          tempFilePath: tempFile.path,
          dirType: DirType.download,
          dirName: DirName.download,
        );

        if (result != null) {
          emit(VerifyRequestReportDownloadedState(tempFile.path));
        } else {
          emit(VerifyRequestReportErrorState(
              'Failed to save PDF to downloads folder.'));
        }
      } else {
        emit(VerifyRequestReportErrorState('Unexpected response format.'));
      }
    } catch (e) {
      emit(VerifyRequestReportErrorState('An error occurred: $e'));
    }
  }

  Future<void> verifyServiceReport({
    required String token,
    required String uuid,
    required int service_id,
    required String service_name,
  }) async {
    emit(VerifyRequestReportLoadingState());
    try {
      final response = await _apiService.VerifyServiceReportDownload(
        token: token,
        uuid: uuid,
        service_id: service_id,
      );

      if (response.data is List<int>) {
        final pdfBytes = response.data as List<int>;

        // 1. Write to a temporary file
        final tempDir = await getTemporaryDirectory();
        final tempFileName = '${service_name.replaceAll(' ', '_')}_$uuid.pdf';
        final tempFilePath = '${tempDir.path}/$tempFileName';
        final tempFile = File(tempFilePath);
        await tempFile.writeAsBytes(pdfBytes);

        // 2. Initialize MediaStore and save to Downloads
        await MediaStore.ensureInitialized();
        MediaStore.appFolder = "vverify";

        final result = await MediaStore().saveFile(
          tempFilePath: tempFile.path,
          dirType: DirType.download,
          dirName: DirName.download,
        );

        if (result != null) {
          emit(VerifyRequestReportDownloadedState(tempFile.path));
        } else {
          emit(VerifyRequestReportErrorState(
              'Failed to save report to downloads folder.'));
        }
      } else {
        emit(VerifyRequestReportErrorState('Unexpected response format.'));
      }
    } catch (e) {
      emit(VerifyRequestReportErrorState('An error occurred: $e'));
    }
  }
}
