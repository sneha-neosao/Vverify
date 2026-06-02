// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) =>
    LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  int? status;
  String? message;
  String? mobile;
  String? otp;

  LoginModel({
    this.status,
    this.message,
    this.mobile,
    this.otp,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        status: json["status"],
        message: json["message"],
        mobile: json["mobile"],
        otp: json["otp"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "mobile": mobile,
        "otp": otp,
      };
}
