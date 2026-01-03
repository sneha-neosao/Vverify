// To parse this JSON data, do
//
//     final nameAddressShowDataModel = nameAddressShowDataModelFromJson(jsonString);

import 'dart:convert';

NameAddressShowDataModel nameAddressShowDataModelFromJson(String str) => NameAddressShowDataModel.fromJson(json.decode(str));

String nameAddressShowDataModelToJson(NameAddressShowDataModel data) => json.encode(data.toJson());

class NameAddressShowDataModel {
  int? status;
  String? message;
  Data? data;

  NameAddressShowDataModel({
    this.status,
    this.message,
    this.data,
  });

  factory NameAddressShowDataModel.fromJson(Map<String, dynamic> json) => NameAddressShowDataModel(
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
  int? serviceRequestId;
  int? requestId;
  String? personName;
  String? personPermanentAddress;
  String? addressLine1;
  String? addressLine2;
  String? city;
  String? pincode;
  dynamic aadhaarFrontSide;
  dynamic aadhaarBackSide;
  String? status;
  String? dataPreference;
  String? reason;

  Data({
    this.id,
    this.uid,
    this.serviceRequestId,
    this.requestId,
    this.personName,
    this.personPermanentAddress,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.pincode,
    this.aadhaarFrontSide,
    this.aadhaarBackSide,
    this.status,
    this.dataPreference,
    this.reason,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    uid: json["uid"],
    serviceRequestId: json["service_request_id"],
    requestId: json["request_id"],
    personName: json["person_name"],
    personPermanentAddress: json["person_permanent_address"],
    addressLine1: json["address_line_1"],
    addressLine2: json["address_line_2"],
    city: json["city"],
    pincode: json["pincode"],
    aadhaarFrontSide: json["aadhaar_front_side"],
    aadhaarBackSide: json["aadhaar_back_side"],
    status: json["status"],
    dataPreference: json["data_preference"],
    reason: json["reason"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "uid": uid,
    "service_request_id": serviceRequestId,
    "request_id": requestId,
    "person_name": personName,
    "person_permanent_address": personPermanentAddress,
    "address_line_1": addressLine1,
    "address_line_2": addressLine2,
    "city": city,
    "pincode": pincode,
    "aadhaar_front_side": aadhaarFrontSide,
    "aadhaar_back_side": aadhaarBackSide,
    "status": status,
    "data_preference": dataPreference,
    "reason": reason,
  };
}
