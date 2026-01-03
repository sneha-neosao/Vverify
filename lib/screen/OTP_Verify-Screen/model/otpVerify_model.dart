// To parse this JSON data, do
//
//     final otpVerifyModel = otpVerifyModelFromJson(jsonString);

import 'dart:convert';

OtpVerifyModel otpVerifyModelFromJson(String str) =>
    OtpVerifyModel.fromJson(json.decode(str));

String otpVerifyModelToJson(OtpVerifyModel data) => json.encode(data.toJson());

class OtpVerifyModel {
  int? status;
  String? message;
  Result? result;
  String? token;
  int? accountExist;

  OtpVerifyModel({
    this.status,
    this.message,
    this.result,
    this.token,
    this.accountExist,
  });

  factory OtpVerifyModel.fromJson(Map<String, dynamic> json) => OtpVerifyModel(
        status: json["status"],
        message: json["message"],
        result: json["result"] == null ? null : Result.fromJson(json["result"]),
        token: json["token"],
        accountExist: json["accountExist"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": result?.toJson(),
        "token": token,
        "accountExist": accountExist,
      };
}

class Result {
  int? id;
  String? userType;
  int? userTypeId;
  String? customerName;
  String? mobileNumber;
  String? email;
  String? profilePhoto;

  Result({
    this.id,
    this.userType,
    this.userTypeId,
    this.customerName,
    this.mobileNumber,
    this.email,
    this.profilePhoto,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        userType: json["userType"],
        userTypeId: json["userTypeId"],
        customerName: json["customerName"],
        mobileNumber: json["mobileNumber"],
        email: json["email"],
        profilePhoto: json["profilePhoto"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userType": userType,
        "userTypeId": userTypeId,
        "customerName": customerName,
        "mobileNumber": mobileNumber,
        "email": email,
        "profilePhoto": profilePhoto,
      };
}
