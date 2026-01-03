// To parse this JSON data, do
//
//     final employListDataModel = employListDataModelFromJson(jsonString);

import 'dart:convert';

EmployListDataModel employListDataModelFromJson(String str) => EmployListDataModel.fromJson(json.decode(str));

String employListDataModelToJson(EmployListDataModel data) => json.encode(data.toJson());

class EmployListDataModel {
  int? status;
  String? message;
  List<Datum>? data;

  EmployListDataModel({
    this.status,
    this.message,
    this.data,
  });

  factory EmployListDataModel.fromJson(Map<String, dynamic> json) => EmployListDataModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
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
  String? salary;
  String? currency;
  String? payFrequency;
  String? hrContactName;
  dynamic hrContactEmail;
  dynamic hrContactPhone;
  String? employmentCertificateNumber;
  String? employmentLetterDoc;
  String? employmentSupportingDoc;
  String? status;
  String? dataPreference;

  Datum({
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
    this.salary,
    this.currency,
    this.payFrequency,
    this.hrContactName,
    this.hrContactEmail,
    this.hrContactPhone,
    this.employmentCertificateNumber,
    this.employmentLetterDoc,
    this.employmentSupportingDoc,
    this.status,
    this.dataPreference,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
    salary: json["salary"],
    currency: json["currency"],
    payFrequency: json["pay_frequency"],
    hrContactName: json["hr_contact_name"],
    hrContactEmail: json["hr_contact_email"],
    hrContactPhone: json["hr_contact_phone"],
    employmentCertificateNumber: json["employment_certificate_number"],
    employmentLetterDoc: json["employment_letter_doc"],
    employmentSupportingDoc: json["employment_supporting_doc"],
    status: json["status"],
    dataPreference: json["data_preference"],
  );

  Map<String, dynamic> toJson() => {
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
    "joining_date": joiningDate,
    "exit_date": exitDate,
    "experience_years": experienceYears,
    "experience_months": experienceMonths,
    "employment_status": employmentStatus,
    "salary": salary,
    "currency": currency,
    "pay_frequency": payFrequency,
    "hr_contact_name": hrContactName,
    "hr_contact_email": hrContactEmail,
    "hr_contact_phone": hrContactPhone,
    "employment_certificate_number": employmentCertificateNumber,
    "employment_letter_doc": employmentLetterDoc,
    "employment_supporting_doc": employmentSupportingDoc,
    "status": status,
    "data_preference": dataPreference,
  };
}
