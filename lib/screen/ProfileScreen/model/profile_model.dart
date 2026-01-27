// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'dart:convert';

ProfileModel profileModelFromJson(String str) => ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
  int? status;
  String? message;
  ProfileResult? profileResult;

  ProfileModel({
    this.status,
    this.message,
    this.profileResult,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    status: json["status"],
    message: json["message"],
    profileResult: json["result"] == null ? null : ProfileResult.fromJson(json["result"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "result": profileResult?.toJson(),
  };
}

class ProfileResult {
  int? id;
  String? userType;
  int? userTypeId;
  String? firstName;
  String? lastName;
  String? mobileNumber;
  String? email;
  int? isAgree;
  String? profilePhoto;
  String? companyName;
  String? companyHr;
  String? companyHrNumber;
  String? companyEmail;
  String? companyAddress;
  String? salutation;

  ProfileResult({
    this.id,
    this.userType,
    this.userTypeId,
    this.firstName,
    this.lastName,
    this.mobileNumber,
    this.email,
    this.isAgree,
    this.profilePhoto,
    this.companyName,
    this.companyHr,
    this.companyHrNumber,
    this.companyEmail,
    this.companyAddress,
    this.salutation
  });

  factory ProfileResult.fromJson(Map<String, dynamic> json) => ProfileResult(
    id: json["id"],
    userType: json["userType"],
    userTypeId: json["userTypeId"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    mobileNumber: json["mobileNumber"],
    email: json["email"],
    isAgree: json["isAgree"],
    profilePhoto: json["profilePhoto"],
    companyName: json["companyName"],
    companyHr: json["contactPersonName"],
    companyHrNumber: json["contactPersonPhone"],
    companyEmail: json["companyEmail"],
    companyAddress: json["companyAddress"],
    salutation: json["contactPersonSalutation"]
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userType": userType,
    "userTypeId": userTypeId,
    "firstName": firstName,
    "lastName": lastName,
    "mobileNumber": mobileNumber,
    "email": email,
    "isAgree": isAgree,
    "profilePhoto": profilePhoto,
    "companyName": companyName,
    "contactPersonName": companyHr,
    "contactPersonPhone": companyHrNumber,
    "companyEmail": companyEmail,
    "companyAddress": companyAddress,
    "contactPersonSalutation": salutation
  };
}
