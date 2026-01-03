// To parse this JSON data, do
//
//     final drivingLicenceShowDataModel = drivingLicenceShowDataModelFromJson(jsonString);

import 'dart:convert';

DrivingLicenceShowDataModel drivingLicenceShowDataModelFromJson(String str) => DrivingLicenceShowDataModel.fromJson(json.decode(str));

String drivingLicenceShowDataModelToJson(DrivingLicenceShowDataModel data) => json.encode(data.toJson());

class DrivingLicenceShowDataModel {
  int? status;
  String? message;
  Data? data;

  DrivingLicenceShowDataModel({
    this.status,
    this.message,
    this.data,
  });

  factory DrivingLicenceShowDataModel.fromJson(Map<String, dynamic> json) => DrivingLicenceShowDataModel(
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
  dynamic driverLicenceNumber;
  dynamic dob;
  String? status;
  dynamic dataPreference;
  String? reason;
  String? dataDocument;

  Data({
    this.id,
    this.uid,
    this.requestId,
    this.serviceRequestId,
    this.driverLicenceNumber,
    this.dob,
    this.status,
    this.dataPreference,
    this.reason,
    this.dataDocument,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    uid: json["uid"],
    requestId: json["request_id"],
    serviceRequestId: json["service_request_id"],
    driverLicenceNumber: json["driver_licence_number"],
    dob: json["dob"],
    status: json["status"],
    dataPreference: json["data_preference"],
    reason: json["reason"],
    dataDocument: json["data_document"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "uid": uid,
    "request_id": requestId,
    "service_request_id": serviceRequestId,
    "driver_licence_number": driverLicenceNumber,
    "dob": dob,
    "status": status,
    "data_preference": dataPreference,
    "reason": reason,
    "data_document": dataDocument,
  };
}
