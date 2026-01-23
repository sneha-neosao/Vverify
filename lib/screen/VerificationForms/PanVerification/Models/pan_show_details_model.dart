// To parse this JSON data, do
//
//     final panVerificationShowModel = panVerificationShowModelFromJson(jsonString);

import 'dart:convert';

PanVerificationShowModel panVerificationShowModelFromJson(String str) => PanVerificationShowModel.fromJson(json.decode(str));

String panVerificationShowModelToJson(PanVerificationShowModel data) => json.encode(data.toJson());

class PanVerificationShowModel {
  int? status;
  String? message;
  Data? data;

  PanVerificationShowModel({
    this.status,
    this.message,
    this.data,
  });

  factory PanVerificationShowModel.fromJson(Map<String, dynamic> json) => PanVerificationShowModel(
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

  Data({
    this.id,
    this.uid,
    this.requestId,
    this.serviceRequestId,
    this.panNumber,
    this.status,
    this.dataPreference,
    this.reason,
    this.documentType
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
    documentType: json["documentType"],
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
    "documentType": documentType
  };
}
