import '../../../Order Details/model/order_details_model.dart';

class VerifyDetailsModel {
  int? status;
  String? message;
  Data? data;

  VerifyDetailsModel({this.status, this.message, this.data});

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
  String? dob; // keep as String, backend sends "" or "YYYY-MM-DD"
  int? detailsUpdated;
  int? isActive;
  int? isDelete;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? requestId;
  String? status;
  String? firstName;
  String? middleName;
  String? lastName;
  String? employeeCode;
  String? dateOfJoining;
  String? gender;
  String? caseUuid;
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
    this.status,
    this.firstName,
    this.middleName,
    this.lastName,
    this.employeeCode,
    this.dateOfJoining,
    this.gender,
    this.caseUuid,
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
        requestId: json["request_id"],
        status: json["status"],
        firstName: json["first_name"],
        middleName: json["middle_name"],
        lastName: json["last_name"],
        employeeCode: json["employee_code"],
        dateOfJoining: json["date_of_joining"],
        gender: json["gender"],
        caseUuid: json["case_uuid"],
        services: json["services"] == null
            ? []
            : List<Service>.from(
                json["services"].map((x) => Service.fromJson(x))),
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
        "dob": dob,
        "details_updated": detailsUpdated,
        "is_active": isActive,
        "is_delete": isDelete,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "request_id": requestId,
        "status": status,
        "first_name": firstName,
        "middle_name": middleName,
        "last_name": lastName,
        "employee_code": employeeCode,
        "date_of_joining": dateOfJoining,
        "gender": gender,
        "case_uuid": caseUuid,
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
      };
}
