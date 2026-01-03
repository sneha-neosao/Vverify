// To parse this JSON data, do
//
//     final employmentShowDataModel = employmentShowDataModelFromJson(jsonString);

import 'dart:convert';

EmploymentShowDataModel employmentShowDataModelFromJson(String str) =>
    EmploymentShowDataModel.fromJson(json.decode(str));

String employmentShowDataModelToJson(EmploymentShowDataModel data) =>
    json.encode(data.toJson());

class EmploymentShowDataModel {
  int? status;
  String? message;
  Data? data;

  EmploymentShowDataModel({
    this.status,
    this.message,
    this.data,
  });

  factory EmploymentShowDataModel.fromJson(Map<String, dynamic> json) =>
      EmploymentShowDataModel(
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
  String? fullName;
  String? companyName;
  String? companyAddress;
  String? companyCity;
  String? companyState;
  String? companyCountry;
  String? companyPostalCode;
  String? industry;
  String? employmentType;
  String? jobTitle;
  String? department;
  String? employeeCodeId;
  String? joiningDate;
  String? exitDate;
  int? experienceYears;
  dynamic experienceMonths;
  String? employmentStatus;
  dynamic reasonForLeaving;
  String? other_reason_for_leaving;
  String? amount;
  String? currency;
  String? salary_drawn;
  dynamic hrContactName;
  dynamic hrContactEmail;
  dynamic hrContactPhone;
  String? employmentCertificateNumber;
  String? employmentLetterDoc;
  String? employmentSupportingDoc;
  int? showOnReport;
  dynamic statusUserId;
  String? reason;
  String? status;
  DateTime? requestedAt;
  dynamic verifiedAt;
  dynamic apiRequest;
  dynamic apiResponse;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? joining_date_format;
  String? leaving_date_format;

  Data({
    this.id,
    this.uid,
    this.requestId,
    this.serviceRequestId,
    this.fullName,
    this.companyName,
    this.companyAddress,
    this.companyCity,
    this.companyState,
    this.companyCountry,
    this.companyPostalCode,
    this.industry,
    this.employmentType,
    this.jobTitle,
    this.department,
    this.employeeCodeId,
    this.joiningDate,
    this.exitDate,
    this.experienceYears,
    this.experienceMonths,
    this.employmentStatus,
    this.reasonForLeaving,
    this.other_reason_for_leaving,
    this.amount,
    this.currency,
    this.salary_drawn,
    this.hrContactName,
    this.hrContactEmail,
    this.hrContactPhone,
    this.employmentCertificateNumber,
    this.employmentLetterDoc,
    this.employmentSupportingDoc,
    this.showOnReport,
    this.statusUserId,
    this.reason,
    this.status,
    this.requestedAt,
    this.verifiedAt,
    this.apiRequest,
    this.apiResponse,
    this.createdAt,
    this.updatedAt,
    this.joining_date_format,
    this.leaving_date_format,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        uid: json["uid"],
        requestId: json["request_id"],
        serviceRequestId: json["service_request_id"],
        fullName: json["full_name"],
        companyName: json["company_name"],
        companyAddress: json["company_address"],
        companyCity: json["company_city"],
        companyState: json["company_state"],
        companyCountry: json["company_country"],
        companyPostalCode: json["company_postal_code"],
        industry: json["industry"],
        employmentType: json["employment_type"],
        jobTitle: json["job_title"],
        department: json["department"],
        employeeCodeId: json["employee_code_id"],
        joiningDate: (json["joining_date"]),
        exitDate: (json["exit_date"]),
        experienceYears: json["experience_years"],
        experienceMonths: json["experience_months"],
        employmentStatus: json["employment_status"],
        reasonForLeaving: json["reason_for_leaving"],
        other_reason_for_leaving: json["other_reason_for_leaving"],
        amount: json["amount"],
        currency: json["currency"],
        salary_drawn: json["salary_drawn"],
        hrContactName: json["hr_contact_name"],
        hrContactEmail: json["hr_contact_email"],
        hrContactPhone: json["hr_contact_phone"],
        employmentCertificateNumber: json["employment_certificate_number"],
        employmentLetterDoc: json["employment_letter_doc"],
        employmentSupportingDoc: json["employment_supporting_doc"],
        joining_date_format: json["joining_date_format"],
        leaving_date_format: json["leaving_date_format"],
        showOnReport: json["show_on_report"],
        statusUserId: json["status_user_id"],
        reason: json["reason"],
        status: json["status"],
        requestedAt: json["requested_at"] == null
            ? null
            : DateTime.parse(json["requested_at"]),
        verifiedAt: json["verified_at"],
        apiRequest: json["api_request"],
        apiResponse: json["api_response"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "uid": uid,
        "request_id": requestId,
        "service_request_id": serviceRequestId,
        "full_name": fullName,
        "company_name": companyName,
        "company_address": companyAddress,
        "company_city": companyCity,
        "company_state": companyState,
        "company_country": companyCountry,
        "company_postal_code": companyPostalCode,
        "industry": industry,
        "employment_type": employmentType,
        "job_title": jobTitle,
        "department": department,
        "employee_code_id": employeeCodeId,
        "joining_date": joiningDate!,
        "exit_date": exitDate,
        "experience_years": experienceYears,
        "experience_months": experienceMonths,
        "employment_status": employmentStatus,
        "reason_for_leaving": reasonForLeaving,
        "other_reason_for_leaving": other_reason_for_leaving,
        "amount": amount,
        "currency": currency,
        "salary_drawn": salary_drawn,
        "hr_contact_name": hrContactName,
        "hr_contact_email": hrContactEmail,
        "hr_contact_phone": hrContactPhone,
        "employment_certificate_number": employmentCertificateNumber,
        "employment_letter_doc": employmentLetterDoc,
        "employment_supporting_doc": employmentSupportingDoc,
        "joining_date_format": joining_date_format,
        "leaving_date_format": leaving_date_format,
        "show_on_report": showOnReport,
        "status_user_id": statusUserId,
        "reason": reason,
        "status": status,
        "requested_at": requestedAt?.toIso8601String(),
        "verified_at": verifiedAt,
        "api_request": apiRequest,
        "api_response": apiResponse,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
