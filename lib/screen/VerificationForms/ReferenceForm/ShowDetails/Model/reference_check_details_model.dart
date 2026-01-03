// To parse this JSON data, do
//
//     final referenceCheckDetailsModel = referenceCheckDetailsModelFromJson(jsonString);

import 'dart:convert';
ReferenceCheckDetailsModel referenceCheckDetailsModelFromJson(String str) =>
    ReferenceCheckDetailsModel.fromJson(json.decode(str));

String referenceCheckDetailsModelToJson(ReferenceCheckDetailsModel data) =>
    json.encode(data.toJson());

class ReferenceCheckDetailsModel {
  int? status;
  String? message;
  Data? data;

  ReferenceCheckDetailsModel({
    this.status,
    this.message,
    this.data,
  });

  factory ReferenceCheckDetailsModel.fromJson(Map<String, dynamic> json) =>
      ReferenceCheckDetailsModel(
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
  String? personName1;
  String? personMobileNumber1;
  String? personAddress1;
  String? personRelation1;
  String? personName2;
  String? personMobileNumber2;
  String? personAddress2;
  String? personRelation2;
  String? reason;
  String? status;

  Data({
    this.id,
    this.uid,
    this.requestId,
    this.serviceRequestId,
    this.personName1,
    this.personMobileNumber1,
    this.personAddress1,
    this.personRelation1,
    this.personName2,
    this.personMobileNumber2,
    this.personAddress2,
    this.personRelation2,
    this.reason,
    this.status,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        uid: json["uid"],
        requestId: json["request_id"],
        serviceRequestId: json["service_request_id"],
        personName1: json["person_name_1"],
        personMobileNumber1: json["person_mobile_number_1"],
        personAddress1: json["person_address_1"],
        personRelation1: json["person_relation_1"],
        personName2: json["person_name_2"],
        personMobileNumber2: json["person_mobile_number_2"],
        personAddress2: json["person_address_2"],
        personRelation2: json["person_relation_2"],
        reason: json["reason"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "uid": uid,
        "request_id": requestId,
        "service_request_id": serviceRequestId,
        "person_name_1": personName1,
        "person_mobile_number_1": personMobileNumber1,
        "person_address_1": personAddress1,
        "person_relation_1": personRelation1,
        "person_name_2": personName2,
        "person_mobile_number_2": personMobileNumber2,
        "person_address_2": personAddress2,
        "person_relation_2": personRelation2,
        "reason": reason,
        "status": status,
      };
}
