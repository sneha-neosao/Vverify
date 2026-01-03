// To parse this JSON data, do
//
//     final verifyDetailsModel = verifyDetailsModelFromJson(jsonString);

import 'dart:convert';

VerifyDetailsModel verifyDetailsModelFromJson(String str) =>
    VerifyDetailsModel.fromJson(json.decode(str));

String verifyDetailsModelToJson(VerifyDetailsModel data) =>
    json.encode(data.toJson());

class VerifyDetailsModel {
  int? status;
  String? message;
  Data? data;

  VerifyDetailsModel({
    this.status,
    this.message,
    this.data,
  });

  factory VerifyDetailsModel.fromJson(Map<String, dynamic> json) =>
      VerifyDetailsModel(
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
  String? uuid;
  int? customerId;
  int? entityId;
  String? name;
  String? phone;
  String? email;
  DateTime? dob;
  int? detailsUpdated;
  int? isActive;
  int? isDelete;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? requestId;
  List<Service>? services;
  Entity? entity;
  Customer? customer;

  Data({
    this.id,
    this.uuid,
    this.customerId,
    this.entityId,
    this.name,
    this.phone,
    this.email,
    this.dob,
    this.detailsUpdated,
    this.isActive,
    this.isDelete,
    this.createdAt,
    this.updatedAt,
    this.requestId,
    this.services,
    this.entity,
    this.customer,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        uuid: json["uuid"],
        customerId: json["customer_id"],
        entityId: json["entity_id"],
        name: json["name"],
        phone: json["phone"],
        email: json["email"],
        dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
        detailsUpdated: json["details_updated"],
        isActive: json["is_active"],
        isDelete: json["is_delete"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        requestId: json["request_id"],
        services: json["services"] == null
            ? []
            : List<Service>.from(
                json["services"]!.map((x) => Service.fromJson(x))),
        entity: json["entity"] == null ? null : Entity.fromJson(json["entity"]),
        customer: json["customer"] == null
            ? null
            : Customer.fromJson(json["customer"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "uuid": uuid,
        "customer_id": customerId,
        "entity_id": entityId,
        "name": name,
        "phone": phone,
        "email": email,
        "dob":
            "${dob!.year.toString().padLeft(4, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}",
        "details_updated": detailsUpdated,
        "is_active": isActive,
        "is_delete": isDelete,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "request_id": requestId,
        "services": services == null
            ? []
            : List<dynamic>.from(services!.map((x) => x.toJson())),
        "entity": entity?.toJson(),
        "customer": customer?.toJson(),
      };
}

class Customer {
  int? id;
  int? userTypeId;
  String? firstName;
  String? lastName;
  String? customerEmail;
  String? customerMobileNumber;
  dynamic customerOtp;
  String? customerAvatar;
  int? isActive;
  int? isDelete;
  int? isBlock;
  DateTime? createdAt;
  DateTime? updatedAt;

  Customer({
    this.id,
    this.userTypeId,
    this.firstName,
    this.lastName,
    this.customerEmail,
    this.customerMobileNumber,
    this.customerOtp,
    this.customerAvatar,
    this.isActive,
    this.isDelete,
    this.isBlock,
    this.createdAt,
    this.updatedAt,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json["id"],
        userTypeId: json["user_type_id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        customerEmail: json["customer_email"],
        customerMobileNumber: json["customer_mobile_number"],
        customerOtp: json["customer_otp"],
        customerAvatar: json["customer_avatar"],
        isActive: json["is_active"],
        isDelete: json["is_delete"],
        isBlock: json["is_block"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_type_id": userTypeId,
        "first_name": firstName,
        "last_name": lastName,
        "customer_email": customerEmail,
        "customer_mobile_number": customerMobileNumber,
        "customer_otp": customerOtp,
        "customer_avatar": customerAvatar,
        "is_active": isActive,
        "is_delete": isDelete,
        "is_block": isBlock,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class Entity {
  int? id;
  String? entityName;
  int? isActive;
  int? isDelete;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? entityIcon;

  Entity({
    this.id,
    this.entityName,
    this.isActive,
    this.isDelete,
    this.createdAt,
    this.updatedAt,
    this.entityIcon,
  });

  factory Entity.fromJson(Map<String, dynamic> json) => Entity(
        id: json["id"],
        entityName: json["entity_name"],
        isActive: json["is_active"],
        isDelete: json["is_delete"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        entityIcon: json["entity_icon"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "entity_name": entityName,
        "is_active": isActive,
        "is_delete": isDelete,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "entity_icon": entityIcon,
      };
}

class Service {
  int? serviceRequestId;
  int? serviceId;
  String? serviceTitle;
  String? serviceIcon;
  String? status;

  Service({
    this.serviceRequestId,
    this.serviceId,
    this.serviceTitle,
    this.serviceIcon,
    this.status,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        serviceRequestId: json["service_request_id"],
        serviceId: json["service_id"],
        serviceTitle: json["service_title"],
        serviceIcon: json["service_icon"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "service_request_id": serviceRequestId,
        "service_id": serviceId,
        "service_title": serviceTitle,
        "service_icon": serviceIcon,
        "status": status,
      };
}
