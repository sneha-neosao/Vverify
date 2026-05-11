import '../model/aadhaar_ocr_model.dart';

abstract class AadhaarOcrState {}

class AadhaarOcrInitial extends AadhaarOcrState {}

class AadhaarOcrLoading extends AadhaarOcrState {}

class AadhaarOcrSuccess extends AadhaarOcrState {
  final AadhaarOcrModel ocrData;
  AadhaarOcrSuccess(this.ocrData);
}

class AadhaarOcrFailure extends AadhaarOcrState {
  final String error;
  AadhaarOcrFailure(this.error);
}
