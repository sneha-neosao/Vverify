import 'dart:convert';

ShowCourtDataModel showCourtDataModelFromJson(String str) => ShowCourtDataModel.fromJson(json.decode(str));

String showCourtDataModelToJson(ShowCourtDataModel data) => json.encode(data.toJson());

class ShowCourtDataModel {
  int? status;
  String? message;
  Data? data;

  ShowCourtDataModel({
    this.status,
    this.message,
    this.data,
  });

  factory ShowCourtDataModel.fromJson(Map<String, dynamic> json) => ShowCourtDataModel(
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
  String? firstName;
  String? lastName;
  String? fatherName;
  String? address;
  DateTime? dob;
  String? status;
  String? reason;
  String? aadhaarDocument;
  String? panDocument;

  Data({
    this.id,
    this.uid,
    this.requestId,
    this.serviceRequestId,
    this.firstName,
    this.lastName,
    this.fatherName,
    this.address,
    this.dob,
    this.status,
    this.reason,
    this.aadhaarDocument,
    this.panDocument,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    uid: json["uid"],
    requestId: json["request_id"],
    serviceRequestId: json["service_request_id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    fatherName: json["father_name"],
    address: json["address"],
    dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
    status: json["status"],
    reason: json["reason"],
    aadhaarDocument: json["aadhaar_document"],
    panDocument: json["pan_document"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "uid": uid,
    "request_id": requestId,
    "service_request_id": serviceRequestId,
    "first_name": firstName,
    "last_name": lastName,
    "father_name": fatherName,
    "address": address,
    "dob": dob?.toIso8601String(),
    "status": status,
    "reason": reason,
    "aadhaar_document": aadhaarDocument,
    "pan_document": panDocument,
  };
}
