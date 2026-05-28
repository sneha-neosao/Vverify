// To parse this JSON data, do
//
//     final panVerificationShowModel = panVerificationShowModelFromJson(jsonString);

import 'dart:convert';

PanVerificationShowModel panVerificationShowModelFromJson(String str) =>
    PanVerificationShowModel.fromJson(json.decode(str));

String panVerificationShowModelToJson(PanVerificationShowModel data) =>
    json.encode(data.toJson());

class PanVerificationShowModel {
  int? status;
  String? message;
  Data? data;

  PanVerificationShowModel({
    this.status,
    this.message,
    this.data,
  });

  factory PanVerificationShowModel.fromJson(Map<String, dynamic> json) =>
      PanVerificationShowModel(
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
  String? panNumber;
  String? status;
  String? dataPreference;
  String? reason;
  String? documentType;
  String? documentNumber;
  List<String>? documents;
  String? documentPdfFile;
  String? dob;
  String? documentScanFile;

  Data({
    this.id,
    this.uid,
    this.requestId,
    this.serviceRequestId,
    this.panNumber,
    this.status,
    this.dataPreference,
    this.reason,
    this.documentType,
    this.documentNumber,
    this.documents,
    this.documentPdfFile,
    this.dob,
    this.documentScanFile,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        uid: json["uid"],
        requestId: json["request_id"],
        serviceRequestId: json["service_request_id"],
        panNumber: json["pan_number"],
        status: json["status"],
        dataPreference: json["data_preference"],
        reason: json["reason"],
        documentType: json["document_type"],
        documentNumber: json["document_number"],
        documents: json["documents"] == null
            ? []
            : List<String>.from(json["documents"].map((x) => x)),
        documentPdfFile: json["document_pdf_file"],
        dob: json["dob"],
        documentScanFile: json["document_scan_file"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "uid": uid,
        "request_id": requestId,
        "service_request_id": serviceRequestId,
        "pan_number": panNumber,
        "status": status,
        "data_preference": dataPreference,
        "reason": reason,
        "document_type": documentType,
        "document_number": documentNumber,
        "documents": documents,
        "document_pdf_file": documentPdfFile,
        "dob": dob,
        "document_scan_file": documentScanFile,
      };
}
