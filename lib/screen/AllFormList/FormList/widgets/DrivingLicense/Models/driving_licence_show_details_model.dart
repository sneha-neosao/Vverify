// To parse this JSON data, do
//
//     final drivingLicenceShowDataModel = drivingLicenceShowDataModelFromJson(jsonString);

import 'dart:convert';

DrivingLicenceShowDataModel drivingLicenceShowDataModelFromJson(String str) =>
    DrivingLicenceShowDataModel.fromJson(json.decode(str));

String drivingLicenceShowDataModelToJson(DrivingLicenceShowDataModel data) =>
    json.encode(data.toJson());

class DrivingLicenceShowDataModel {
  int? status;
  String? message;
  Data? data;

  DrivingLicenceShowDataModel({
    this.status,
    this.message,
    this.data,
  });

  factory DrivingLicenceShowDataModel.fromJson(Map<String, dynamic> json) =>
      DrivingLicenceShowDataModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  int? id;
  String? uid;
  int? requestId;
  int? serviceRequestId;
  int? serviceId;
  String? documentType;
  dynamic documentNumber;
  dynamic dob;
  String? panNumber;
  String? status;
  dynamic dataPreference;
  String? reason;
  List<dynamic>? documents;
  String? documentPdfFile;
  dynamic documentScanFile;

  Data({
    this.id,
    this.uid,
    this.requestId,
    this.serviceRequestId,
    this.serviceId,
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

  // Backwards-compatible getters
  dynamic get driverLicenceNumber => documentNumber;
  String? get dataDocument => documentPdfFile;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        uid: json["uid"],
        requestId: json["request_id"] is int
            ? json["request_id"]
            : int.tryParse(json["request_id"]?.toString() ?? ""),
        serviceRequestId: json["service_request_id"] is int
            ? json["service_request_id"]
            : int.tryParse(json["service_request_id"]?.toString() ?? ""),
        serviceId: json["service_id"] is int
            ? json["service_id"]
            : int.tryParse(json["service_id"]?.toString() ?? ""),
        documentType: json["document_type"],
        documentNumber:
            json["document_number"] ?? json["driver_licence_number"],
        dob: json["dob"],
        panNumber: json["pan_number"],
        status: json["status"],
        dataPreference: json["data_preference"],
        reason: json["reason"],
        documents: json["documents"] == null
            ? []
            : List<dynamic>.from(json["documents"]),
        documentPdfFile: json["document_pdf_file"] ?? json["data_document"],
        documentScanFile: json["document_scan_file"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "uid": uid,
        "request_id": requestId,
        "service_request_id": serviceRequestId,
        "service_id": serviceId,
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
