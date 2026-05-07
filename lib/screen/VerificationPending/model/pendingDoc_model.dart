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
  String? status;
  String? employeeCode;
  String? dateOfJoining;
  String? gender;
  String? caseUuid;
  String? caseStatus;
  String? companyName;
  String? groupId;
  int? requestId;
  List<Service>? services;
  Entity? entity;
  Customer? customer;

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
    this.status,
    this.employeeCode,
    this.dateOfJoining,
    this.gender,
    this.caseUuid,
    this.caseStatus,
    this.companyName,
    this.groupId,
    this.requestId,
    this.services,
    this.entity,
    this.customer,
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
        dob: json["dob"],
        detailsUpdated: json["details_updated"],
        isActive: json["is_active"],
        isDelete: json["is_delete"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        status: json["status"],
        employeeCode: json["employee_code"],
        dateOfJoining: json["date_of_joining"],
        gender: json["gender"],
        caseUuid: json["case_uuid"],
        caseStatus: json["case_status"],
        companyName: json["company_name"],
        groupId: json["group_id"]?.toString(),
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
        "status": status,
        "employee_code": employeeCode,
        "date_of_joining": dateOfJoining,
        "gender": gender,
        "case_uuid": caseUuid,
        "case_status": caseStatus,
        "company_name": companyName,
        "group_id": groupId,
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
  String? firebaseId;
  int? isChecked;
  String? companyName;
  String? contactPersonHrName;
  String? contactPersonHrPhone;
  String? companyAddress;
  String? companyEmail;
  String? clientId;
  String? contactPersonSalutation;
  String? gstNumber;

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
    this.firebaseId,
    this.isChecked,
    this.companyName,
    this.contactPersonHrName,
    this.contactPersonHrPhone,
    this.companyAddress,
    this.companyEmail,
    this.clientId,
    this.contactPersonSalutation,
    this.gstNumber,
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
        firebaseId: json["firebase_id"],
        isChecked: json["is_checked"],
        companyName: json["company_name"],
        contactPersonHrName: json["contact_person_hr_name"],
        contactPersonHrPhone: json["contact_person_hr_phone"],
        companyAddress: json["company_address"],
        companyEmail: json["company_email"],
        clientId: json["client_id"],
        contactPersonSalutation: json["contact_person_salutation"],
        gstNumber: json["gst_number"],
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
        "firebase_id": firebaseId,
        "is_checked": isChecked,
        "company_name": companyName,
        "contact_person_hr_name": contactPersonHrName,
        "contact_person_hr_phone": contactPersonHrPhone,
        "company_address": companyAddress,
        "company_email": companyEmail,
        "client_id": clientId,
        "contact_person_salutation": contactPersonSalutation,
        "gst_number": gstNumber,
      };
}

class Entity {
  int? id;
  int? groupId;
  String? entityName;
  int? isActive;
  int? isDelete;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? entityIcon;
  String? entityDescription;

  Entity({
    this.id,
    this.groupId,
    this.entityName,
    this.isActive,
    this.isDelete,
    this.createdAt,
    this.updatedAt,
    this.entityIcon,
    this.entityDescription,
  });

  factory Entity.fromJson(Map<String, dynamic> json) => Entity(
        id: json["id"],
        groupId: json["group_id"],
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
        entityDescription: json["entity_description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "group_id": groupId,
        "entity_name": entityName,
        "is_active": isActive,
        "is_delete": isDelete,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "entity_icon": entityIcon,
        "entity_description": entityDescription,
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
  int? isDeveloped;

  Service({
    this.uid,
    this.policeEntryType,
    this.serviceRequestId,
    this.serviceId,
    this.serviceTitle,
    this.serviceNavigate,
    this.serviceIcon,
    this.status,
    this.dataPreference,
    this.isDeveloped,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        uid: json["uid"],
        policeEntryType: json["police_entry_type"],
        serviceRequestId: json["service_request_id"],
        serviceId: json["service_id"],
        serviceTitle: json["service_title"],
        serviceNavigate: json["service_navigate"],
        serviceIcon: json["service_icon"],
        status: json["status"],
        dataPreference: json["data_preference"],
        isDeveloped: json["is_developed"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "police_entry_type": policeEntryType,
        "service_request_id": serviceRequestId,
        "service_id": serviceId,
        "service_title": serviceTitle,
        "service_navigate": serviceNavigate,
        "service_icon": serviceIcon,
        "status": status,
        "data_preference": dataPreference,
        "is_developed": isDeveloped,
      };
}
