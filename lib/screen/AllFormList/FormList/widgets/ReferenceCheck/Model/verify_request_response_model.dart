import 'dart:convert';

VerifyRequestResponseModel verifyRequestResponseModelFromJson(String str) =>
    VerifyRequestResponseModel.fromJson(json.decode(str));

String verifyRequestResponseModelToJson(VerifyRequestResponseModel data) =>
    json.encode(data.toJson());

class VerifyRequestResponseModel {
  int? status;
  String? message;
  VerifyRequestData? data;

  VerifyRequestResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory VerifyRequestResponseModel.fromJson(Map<String, dynamic> json) =>
      VerifyRequestResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : VerifyRequestData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class VerifyRequestData {
  int? id;
  String? uuid;
  int? customerId;
  int? entityId;
  dynamic name;
  String? phone;
  String? email;
  String? dob;
  int? detailsUpdated;
  int? isActive;
  int? isDelete;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic status;
  dynamic firstName;
  dynamic middleName;
  dynamic lastName;
  dynamic employeeCode;
  dynamic dateOfJoining;
  dynamic gender;
  dynamic caseUuid;
  dynamic caseStatus;
  String? companyName;
  String? groupId;
  int? requestId;
  List<VerifyRequestService>? services;
  VerifyRequestEntity? entity;
  VerifyRequestCustomer? customer;
  ReferenceCheckVerification? referenceCheckVerification;

  VerifyRequestData({
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
    this.status,
    this.firstName,
    this.middleName,
    this.lastName,
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
    this.referenceCheckVerification,
  });

  factory VerifyRequestData.fromJson(Map<String, dynamic> json) =>
      VerifyRequestData(
        id: json["id"],
        uuid: json["uuid"],
        customerId: json["customer_id"],
        entityId: json["entity_id"],
        name: json["name"],
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
        firstName: json["first_name"],
        middleName: json["middle_name"],
        lastName: json["last_name"],
        employeeCode: json["employee_code"],
        dateOfJoining: json["date_of_joining"],
        gender: json["gender"],
        caseUuid: json["case_uuid"],
        caseStatus: json["case_status"],
        companyName: json["company_name"],
        groupId: json["group_id"],
        requestId: json["request_id"],
        services: json["services"] == null
            ? []
            : List<VerifyRequestService>.from(
                json["services"].map((x) => VerifyRequestService.fromJson(x))),
        entity: json["entity"] == null
            ? null
            : VerifyRequestEntity.fromJson(json["entity"]),
        customer: json["customer"] == null
            ? null
            : VerifyRequestCustomer.fromJson(json["customer"]),
        referenceCheckVerification: json["reference_check_verification"] == null
            ? null
            : ReferenceCheckVerification.fromJson(
                json["reference_check_verification"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "uuid": uuid,
        "customer_id": customerId,
        "entity_id": entityId,
        "name": name,
        "phone": phone,
        "email": email,
        "dob": dob,
        "details_updated": detailsUpdated,
        "is_active": isActive,
        "is_delete": isDelete,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "status": status,
        "first_name": firstName,
        "middle_name": middleName,
        "last_name": lastName,
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
        "reference_check_verification": referenceCheckVerification?.toJson(),
      };
}

class VerifyRequestService {
  int? serviceRequestId;
  int? serviceId;
  String? serviceTitle;
  String? serviceIcon;
  String? status;
  int? isDeveloped;

  VerifyRequestService({
    this.serviceRequestId,
    this.serviceId,
    this.serviceTitle,
    this.serviceIcon,
    this.status,
    this.isDeveloped,
  });

  factory VerifyRequestService.fromJson(Map<String, dynamic> json) =>
      VerifyRequestService(
        serviceRequestId: json["service_request_id"],
        serviceId: json["service_id"],
        serviceTitle: json["service_title"],
        serviceIcon: json["service_icon"],
        status: json["status"],
        isDeveloped: json["is_developed"],
      );

  Map<String, dynamic> toJson() => {
        "service_request_id": serviceRequestId,
        "service_id": serviceId,
        "service_title": serviceTitle,
        "service_icon": serviceIcon,
        "status": status,
        "is_developed": isDeveloped,
      };
}

class VerifyRequestEntity {
  int? id;
  int? groupId;
  String? entityName;
  int? isActive;
  int? isDelete;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? entityIcon;
  String? entityDescription;
  int? orderId;

  VerifyRequestEntity({
    this.id,
    this.groupId,
    this.entityName,
    this.isActive,
    this.isDelete,
    this.createdAt,
    this.updatedAt,
    this.entityIcon,
    this.entityDescription,
    this.orderId,
  });

  factory VerifyRequestEntity.fromJson(Map<String, dynamic> json) =>
      VerifyRequestEntity(
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
        orderId: json["order_id"],
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
        "order_id": orderId,
      };
}

class VerifyRequestCustomer {
  int? id;
  int? userTypeId;
  String? firstName;
  String? lastName;
  String? customerEmail;
  String? customerMobileNumber;
  dynamic customerOtp;
  dynamic customerAvatar;
  int? isActive;
  int? isDelete;
  int? isBlock;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic firebaseId;
  dynamic isChecked;
  dynamic companyName;
  dynamic contactPersonHrName;
  dynamic contactPersonHrPhone;
  dynamic companyAddress;
  dynamic companyEmail;
  String? clientId;
  dynamic contactPersonSalutation;
  dynamic gstNumber;

  VerifyRequestCustomer({
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

  factory VerifyRequestCustomer.fromJson(Map<String, dynamic> json) =>
      VerifyRequestCustomer(
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

class ReferenceCheckVerification {
  int? id;
  String? uid;
  int? requestId;
  int? serviceRequestId;
  String? personName1;
  String? personMobileNumber1;
  String? personRelation1;
  String? personEmail1;
  String? personAlternateMobile1;
  String? personName2;
  String? personMobileNumber2;
  String? personRelation2;
  String? personEmail2;
  String? personAlternateMobile2;
  String? reason;
  String? status;

  ReferenceCheckVerification({
    this.id,
    this.uid,
    this.requestId,
    this.serviceRequestId,
    this.personName1,
    this.personMobileNumber1,
    this.personRelation1,
    this.personEmail1,
    this.personAlternateMobile1,
    this.personName2,
    this.personMobileNumber2,
    this.personRelation2,
    this.personEmail2,
    this.personAlternateMobile2,
    this.reason,
    this.status,
  });

  factory ReferenceCheckVerification.fromJson(Map<String, dynamic> json) =>
      ReferenceCheckVerification(
        id: json["id"],
        uid: json["uid"],
        requestId: json["request_id"],
        serviceRequestId: json["service_request_id"],
        personName1: json["person_name_1"],
        personMobileNumber1: json["person_mobile_number_1"],
        personRelation1: json["person_relation_1"],
        personEmail1: json["person_email_1"],
        personAlternateMobile1: json["person_alternate_mobile_1"],
        personName2: json["person_name_2"],
        personMobileNumber2: json["person_mobile_number_2"],
        personRelation2: json["person_relation_2"],
        personEmail2: json["person_email_2"],
        personAlternateMobile2: json["person_alternate_mobile_2"],
        reason: json["reason"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "uid": uid,
        "request_id": requestId,
        "service_request_id": serviceRequestId,
        "person_name_1": personName1,
        "person_mobile_number_1": personMobileNumber1,
        "person_relation_1": personRelation1,
        "person_email_1": personEmail1,
        "person_alternate_mobile_1": personAlternateMobile1,
        "person_name_2": personName2,
        "person_mobile_number_2": personMobileNumber2,
        "person_relation_2": personRelation2,
        "person_email_2": personEmail2,
        "person_alternate_mobile_2": personAlternateMobile2,
        "reason": reason,
        "status": status,
      };
}
