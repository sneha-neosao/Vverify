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
  final String? current_address_line_1;
  final String? current_address_line_2;
  final String? current_city_id;
  final String? current_state;
  final String? current_pinCode;
  final String? permanent_address_line_1;
  final String? permanent_address_line_2;
  final String? permanent_city_id;
  final String? permanent_state;
  final String? permanent_pinCode;
  String? dataPreference;
  String? reason;

  Data({
    this.id,
    this.uid,
    this.serviceRequestId,
    this.requestId,
    required this.current_address_line_1,
    required this.current_address_line_2,
    required this.current_city_id,
    required this.current_state,
    required this.current_pinCode,
    required this.permanent_address_line_1,
    required this.permanent_address_line_2,
    required this.permanent_city_id,
    required this.permanent_state,
    required this.permanent_pinCode,
    this.dataPreference,
    this.reason,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    uid: json["uid"],
    serviceRequestId: json["service_request_id"],
    requestId: json["request_id"],
    current_address_line_1: json["current_address_line_1"],
    current_address_line_2: json["current_address_line_2"],
    current_city_id: json["current_city_id"],
    current_state: json["current_state"],
    current_pinCode: json["current_pinCode"],
    permanent_address_line_1: json["permanent_address_line_1"],
    permanent_address_line_2: json["permanent_address_line_2"],
    permanent_city_id: json["permanent_city_id"],
    permanent_state: json["permanent_state"],
    permanent_pinCode: json["permanent_pinCode"],
    dataPreference: json["data_preference"],
    reason: json["reason"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "uid": uid,
    "service_request_id": serviceRequestId,
    "request_id": requestId,
    "current_address_line_1": current_address_line_1,
    "current_address_line_2": current_address_line_2,
    "current_city_id": current_city_id,
    "current_state": current_state,
    "current_pinCode": current_pinCode,
    "permanent_address_line_1": permanent_address_line_1,
    "permanent_address_line_2": permanent_address_line_2,
    "permanent_city_id": permanent_city_id,
    "permanent_state": permanent_state,
    "permanent_pinCode": permanent_pinCode,
    "data_preference": dataPreference,
    "reason": reason,
  };
}
