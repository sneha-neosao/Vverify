import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_verify/apiServices/api_services.dart';
import '../model/aadhaar_ocr_model.dart';
import 'aadhaar_ocr_state.dart';

class AadhaarOcrCubit extends Cubit<AadhaarOcrState> {
  final ApiService _apiService = ApiService();

  AadhaarOcrCubit() : super(AadhaarOcrInitial());

  Future<void> extractAadhaarDetails(File file,
      {String documentType = "adhaar"}) async {
    emit(AadhaarOcrLoading());
    try {
      final response = await _apiService.extractAadhaarOcr(
          file: file, documentType: documentType);

      if (response.statusCode == 200) {
        final model = AadhaarOcrModel.fromJson(response.data);
        emit(AadhaarOcrSuccess(model));
      } else {
        emit(AadhaarOcrFailure(
            "Extraction failed with status: ${response.statusCode}"));
      }
    } catch (e) {
      emit(AadhaarOcrFailure("Error during OCR extraction: $e"));
    }
  }

  void reset() {
    emit(AadhaarOcrInitial());
  }
}
