// To parse this JSON data, do
//
//     final referenceDocShowDataModel = referenceDocShowDataModelFromJson(jsonString);

import 'dart:convert';

ReferenceDocShowDataModel referenceDocShowDataModelFromJson(String str) => ReferenceDocShowDataModel.fromJson(json.decode(str));

String referenceDocShowDataModelToJson(ReferenceDocShowDataModel data) => json.encode(data.toJson());

class ReferenceDocShowDataModel {
  int? status;
  String? message;
  Data? data;

  ReferenceDocShowDataModel({
    this.status,
    this.message,
    this.data,
  });

  factory ReferenceDocShowDataModel.fromJson(Map<String, dynamic> json) => ReferenceDocShowDataModel(
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
  dynamic personName1;
  dynamic personMobileNumber1;
  dynamic personRelation1;
  dynamic personName2;
  dynamic personMobileNumber2;
  dynamic personRelation2;
  String? reason;
  String? status;
  String? dataDocument;
  String? dataPreference;

  Data({
    this.id,
    this.uid,
    this.requestId,
    this.serviceRequestId,
    this.personName1,
    this.personMobileNumber1,
    this.personRelation1,
    this.personName2,
    this.personMobileNumber2,
    this.personRelation2,
    this.reason,
    this.status,
    this.dataDocument,
    this.dataPreference,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    uid: json["uid"],
    requestId: json["request_id"],
    serviceRequestId: json["service_request_id"],
    personName1: json["person_name_1"],
    personMobileNumber1: json["person_mobile_number_1"],
    personRelation1: json["person_relation_1"],
    personName2: json["person_name_2"],
    personMobileNumber2: json["person_mobile_number_2"],
    personRelation2: json["person_relation_2"],
    status: json["status"],
    reason: json["reason"],
    dataDocument: json["data_document"],
    dataPreference: json["data_preference"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "uid": uid,
    "request_id": requestId,
    "service_request_id": serviceRequestId,
    "person_name_1": personName1,
    "person_mobile_number_1": personMobileNumber1,
    "person_relation_1": personRelation1,
    "person_name_2": personName2,
    "person_mobile_number_2": personMobileNumber2,
    "person_relation_2": personRelation2,
    "reason": reason,
    "status": status,
    "data_document": dataDocument,
    "data_preference": dataPreference,
  };
}
