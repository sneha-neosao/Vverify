// To parse this JSON data, do
//
//     final checkoutModel = checkoutModelFromJson(jsonString);

import 'dart:convert';
ApplyCouponModel applyCouponModelFromJson(String str) => ApplyCouponModel.fromJson(json.decode(str));

String applyCouponModelToJson(ApplyCouponModel data) => json.encode(data.toJson());

class ApplyCouponModel {
  int? status;
  String? message;
  ApplyCouponResult? result;

  ApplyCouponModel({
    this.status,
    this.message,
    this.result,
  });

  factory ApplyCouponModel.fromJson(Map<String, dynamic> json) => ApplyCouponModel(
    status: json["status"],
    message: json["message"],
    result: json["result"] == null ? null : ApplyCouponResult.fromJson(json["result"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "result": result?.toJson(),
  };
}

class ApplyCouponResult {
  String? subtotal;
  String? taxPercent;
  String? taxTotal;
  String? discountApplied;
  String? finalAmount;
  CouponDetails? couponDetails;

  ApplyCouponResult({
    this.subtotal,
    this.taxPercent,
    this.taxTotal,
    this.discountApplied,
    this.finalAmount,
    this.couponDetails,
  });

  factory ApplyCouponResult.fromJson(Map<String, dynamic> json) =>
      ApplyCouponResult(
        subtotal: json["subtotal"],
        taxPercent: json["tax_percent"],
        taxTotal: json["tax_total"],
        discountApplied: json["discountApplied"],
        finalAmount: json["finalAmount"],
        couponDetails: json["couponDetails"] == null
            ? null
            : CouponDetails.fromJson(json["couponDetails"]),
      );

  Map<String, dynamic> toJson() => {
    "subtotal": subtotal,
    "tax_percent": taxPercent,
    "tax_total": taxTotal,
    "discountApplied": discountApplied,
    "finalAmount": finalAmount,
    "couponDetails": couponDetails?.toJson(),
  };
}

class CouponDetails {
  int? id;
  String? couponCode;
  String? couponType;
  String? couponAmount;
  int? nextLimit;

  CouponDetails({
    this.id,
    this.couponCode,
    this.couponType,
    this.couponAmount,
    this.nextLimit,
  });

  factory CouponDetails.fromJson(Map<String, dynamic> json) => CouponDetails(
    id: json["id"],
    couponCode: json["couponCode"],
    couponType: json["couponType"],
    couponAmount: json["couponAmount"],
    nextLimit: json["nextLimit"]
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "couponCode": couponCode,
    "couponType": couponType,
    "couponAmount": couponAmount,
    "nextLimit": nextLimit
  };

}