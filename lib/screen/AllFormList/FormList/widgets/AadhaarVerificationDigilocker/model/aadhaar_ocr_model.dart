class AadhaarOcrModel {
  final int? responseCode;
  final String? documentType;
  final bool? isValidDocument;
  final String? confidence;
  final OcrDetails? details;

  AadhaarOcrModel({
    this.responseCode,
    this.documentType,
    this.isValidDocument,
    this.confidence,
    this.details,
  });

  factory AadhaarOcrModel.fromJson(Map<String, dynamic> json) {
    return AadhaarOcrModel(
      responseCode: json['response_code'],
      documentType: json['document_type'],
      isValidDocument: json['is_valid_document'],
      confidence: json['confidence'],
      details:
          json['details'] != null ? OcrDetails.fromJson(json['details']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'response_code': responseCode,
      'document_type': documentType,
      'is_valid_document': isValidDocument,
      'confidence': confidence,
      'details': details?.toJson(),
    };
  }
}

class OcrDetails {
  final String? aadhaarNumber;
  final String? panNumber;
  final String? dlNumber;
  final String? name;
  final String? gender;
  final String? dob;

  OcrDetails({
    this.aadhaarNumber,
    this.panNumber,
    this.dlNumber,
    this.name,
    this.gender,
    this.dob,
  });

  factory OcrDetails.fromJson(Map<String, dynamic> json) {
    return OcrDetails(
      aadhaarNumber: json['aadhaar_number'],
      panNumber: json['pan_number'],
      dlNumber: json['dl_number'],
      name: json['name'],
      gender: json['gender'],
      dob: json['dob'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'aadhaar_number': aadhaarNumber,
      'pan_number': panNumber,
      'dl_number': dlNumber,
      'name': name,
      'gender': gender,
      'dob': dob,
    };
  }
}
