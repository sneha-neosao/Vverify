import 'dart:convert';

DrivingLicenceSaveModel drivingLicenceSaveModelFromJson(String str) =>
    DrivingLicenceSaveModel.fromJson(json.decode(str));

String drivingLicenceSaveModelToJson(DrivingLicenceSaveModel data) =>
    json.encode(data.toJson());

class DrivingLicenceSaveModel {
  int? status;
  String? message;
  DrivingLicenceSaveData? data;

  DrivingLicenceSaveModel({
    this.status,
    this.message,
    this.data,
  });

  factory DrivingLicenceSaveModel.fromJson(Map<String, dynamic> json) =>
      DrivingLicenceSaveModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : DrivingLicenceSaveData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class DrivingLicenceSaveData {
  int? id;
  String? uid;
  int? requestId;
  int? serviceRequestId;
  String? documentType;
  String? documentNumber;
  String? dob;
  String? panNumber;
  String? status;
  String? dataPreference;
  String? reason;
  List<dynamic>? documents;
  String? documentPdfFile;
  dynamic documentScanFile;

  DrivingLicenceSaveData({
    this.id,
    this.uid,
    this.requestId,
    this.serviceRequestId,
    this.documentType,
    this.documentNumber,
    this.dob,
    this.panNumber,
    this.status,
    this.dataPreference,
    this.reason,
    this.documents,
    this.documentPdfFile,
    this.documentScanFile,
  });

  factory DrivingLicenceSaveData.fromJson(Map<String, dynamic> json) =>
      DrivingLicenceSaveData(
        id: json["id"],
        uid: json["uid"],
        requestId: json["request_id"],
        serviceRequestId: json["service_request_id"],
        documentType: json["document_type"],
        documentNumber: json["document_number"],
        dob: json["dob"],
        panNumber: json["pan_number"],
        status: json["status"],
        dataPreference: json["data_preference"],
        reason: json["reason"],
        documents: json["documents"] == null
            ? []
            : List<dynamic>.from(json["documents"]),
        documentPdfFile: json["document_pdf_file"],
        documentScanFile: json["document_scan_file"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "uid": uid,
        "request_id": requestId,
        "service_request_id": serviceRequestId,
        "document_type": documentType,
        "document_number": documentNumber,
        "dob": dob,
        "pan_number": panNumber,
        "status": status,
        "data_preference": dataPreference,
        "reason": reason,
        "documents": documents == null ? [] : List<dynamic>.from(documents!),
        "document_pdf_file": documentPdfFile,
        "document_scan_file": documentScanFile,
      };
}
