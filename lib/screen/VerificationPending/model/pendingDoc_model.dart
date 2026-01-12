// To parse this JSON data, do
//
//     final pendingDocModel = pendingDocModelFromJson(jsonString);

import 'dart:convert';

PendingDocModel pendingDocModelFromJson(String str) =>
    PendingDocModel.fromJson(json.decode(str));

String pendingDocModelToJson(PendingDocModel data) =>
    json.encode(data.toJson());

class PendingDocModel {
  int? status;
  String? message;
  int? pages;
  int? records;
  List<verifyRequest>? data;

  PendingDocModel({
    this.status,
    this.message,
    this.pages,
    this.records,
    this.data,
  });

  factory PendingDocModel.fromJson(Map<String, dynamic> json) =>
      PendingDocModel(
        status: json["status"],
        message: json["message"],
        pages: json["pages"],
        records: json["records"],
        data: json["data"] == null
            ? []
            : List<verifyRequest>.from(
                json["data"]!.map((x) => verifyRequest.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "pages": pages,
        "records": records,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class verifyRequest {
  String? uuid;
  int? customerId;
  int? entityId;
  String? name;
  String? first_name;
  String? middle_name;
  String? last_name;
  String? phone;
  String? email;
  String? dob;
  int? detailsUpdated;
  int? isActive;
  int? isDelete;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? requestId;
  List<Service>? services;
  Entity? entity;
  Customer? customer;
  String? case_uuid;
  String? status;

  verifyRequest({
    this.uuid,
    this.customerId,
    this.entityId,
    this.name,
    this.first_name,
    this.middle_name,
    this.last_name,
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
    this.case_uuid,
    this.status
  });

  factory verifyRequest.fromJson(Map<String, dynamic> json) => verifyRequest(
        uuid: json["uuid"],
        customerId: json["customer_id"],
        entityId: json["entity_id"],
        name: json["name"],
        first_name: json["first_name"],
        middle_name: json["middle_name"],
        last_name: json["last_name"],
        phone: json["phone"],
        email: json["email"],
        dob: json["dob"] ,
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
      case_uuid: json["case_uuid"],
      status: json["status"]
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "customer_id": customerId,
        "entity_id": entityId,
        "name": name,
        "first_name": first_name,
        "middle_name": middle_name,
        "last_name": last_name,
        "phone": phone,
        "email": email,
        "dob": dob,
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
        "case_uuid": case_uuid,
        "status": status
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
  String? uid;
  dynamic policeEntryType;
  int? serviceRequestId;
  int? serviceId;
  String? serviceTitle;
  String? serviceNavigate;
  String? serviceIcon;
  String? status;
  String? dataPreference;

  Service(
      {this.uid,
      this.policeEntryType,
      this.serviceRequestId,
      this.serviceId,
      this.serviceTitle,
      this.serviceNavigate,
      this.serviceIcon,
      this.status,
      this.dataPreference});

  factory Service.fromJson(Map<String, dynamic> json) => Service(
      uid: json["uid"],
      policeEntryType: json["police_entry_type"],
      serviceRequestId: json["service_request_id"],
      serviceId: json["service_id"],
      serviceTitle: json["service_title"],
      serviceNavigate: json["service_navigate"],
      serviceIcon: json["service_icon"],
      status: json["status"],
      dataPreference: json["data_preference"]);

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "police_entry_type": policeEntryType,
        "service_request_id": serviceRequestId,
        "service_id": serviceId,
        "service_title": serviceTitle,
        "service_navigate": serviceNavigate,
        "service_icon": serviceIcon,
        "status": status,
        "data_preference": dataPreference
      };
}
