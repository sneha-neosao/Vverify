// To parse this JSON data, do
//
//     final educationShowDocModel = educationShowDocModelFromJson(jsonString);

import 'dart:convert';

EducationShowDocModel educationShowDocModelFromJson(String str) => EducationShowDocModel.fromJson(json.decode(str));

String educationShowDocModelToJson(EducationShowDocModel data) => json.encode(data.toJson());

class EducationShowDocModel {
  int? status;
  String? message;
  Data? data;

  EducationShowDocModel({
    this.status,
    this.message,
    this.data,
  });

  factory EducationShowDocModel.fromJson(Map<String, dynamic> json) => EducationShowDocModel(
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
  int? universityBoardId;
  int? collegeSchoolId;
  dynamic institutionType;
  dynamic courseDegreeName;
  dynamic courseDegreeType;
  dynamic institutionAddress;
  dynamic institutionCity;
  dynamic institutionState;
  dynamic institutionCountry;
  dynamic institutionPostalCode;
  dynamic yearOfAdmission;
  dynamic yearOfPassing;
  dynamic totalMarks;
  dynamic obtainedMark;
  dynamic percent;
  dynamic gpa;
  dynamic gpaOutOf;
  dynamic certificateNumber;
  dynamic certificateIssuedDate;
  String? document;
  int? statusUserId;
  String? status;
  DateTime? requestedAt;
  dynamic verifiedAt;
  dynamic apiRequest;
  dynamic apiResponse;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic reason;
  String? dataPreference;
  dynamic universityBoard;
  dynamic collegeSchool;

  Data({
    this.id,
    this.uid,
    this.requestId,
    this.serviceRequestId,
    this.universityBoardId,
    this.collegeSchoolId,
    this.institutionType,
    this.courseDegreeName,
    this.courseDegreeType,
    this.institutionAddress,
    this.institutionCity,
    this.institutionState,
    this.institutionCountry,
    this.institutionPostalCode,
    this.yearOfAdmission,
    this.yearOfPassing,
    this.totalMarks,
    this.obtainedMark,
    this.percent,
    this.gpa,
    this.gpaOutOf,
    this.certificateNumber,
    this.certificateIssuedDate,
    this.document,
    this.statusUserId,
    this.status,
    this.requestedAt,
    this.verifiedAt,
    this.apiRequest,
    this.apiResponse,
    this.createdAt,
    this.updatedAt,
    this.reason,
    this.dataPreference,
    this.universityBoard,
    this.collegeSchool,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    uid: json["uid"],
    requestId: json["request_id"],
    serviceRequestId: json["service_request_id"],
    universityBoardId: json["university_board_id"],
    collegeSchoolId: json["college_school_id"],
    institutionType: json["institution_type"],
    courseDegreeName: json["course_degree_name"],
    courseDegreeType: json["course_degree_type"],
    institutionAddress: json["institution_address"],
    institutionCity: json["institution_city"],
    institutionState: json["institution_state"],
    institutionCountry: json["institution_country"],
    institutionPostalCode: json["institution_postal_code"],
    yearOfAdmission: json["year_of_admission"],
    yearOfPassing: json["year_of_passing"],
    totalMarks: json["total_marks"],
    obtainedMark: json["obtained_mark"],
    percent: json["percent"],
    gpa: json["gpa"],
    gpaOutOf: json["gpa_out_of"],
    certificateNumber: json["certificate_number"],
    certificateIssuedDate: json["certificate_issued_date"],
    document: json["document"],
    statusUserId: json["status_user_id"],
    status: json["status"],
    requestedAt: json["requested_at"] == null ? null : DateTime.parse(json["requested_at"]),
    verifiedAt: json["verified_at"],
    apiRequest: json["api_request"],
    apiResponse: json["api_response"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    reason: json["reason"],
    dataPreference: json["data_preference"],
    universityBoard: json["university_board"],
    collegeSchool: json["college_school"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "uid": uid,
    "request_id": requestId,
    "service_request_id": serviceRequestId,
    "university_board_id": universityBoardId,
    "college_school_id": collegeSchoolId,
    "institution_type": institutionType,
    "course_degree_name": courseDegreeName,
    "course_degree_type": courseDegreeType,
    "institution_address": institutionAddress,
    "institution_city": institutionCity,
    "institution_state": institutionState,
    "institution_country": institutionCountry,
    "institution_postal_code": institutionPostalCode,
    "year_of_admission": yearOfAdmission,
    "year_of_passing": yearOfPassing,
    "total_marks": totalMarks,
    "obtained_mark": obtainedMark,
    "percent": percent,
    "gpa": gpa,
    "gpa_out_of": gpaOutOf,
    "certificate_number": certificateNumber,
    "certificate_issued_date": certificateIssuedDate,
    "document": document,
    "status_user_id": statusUserId,
    "status": status,
    "requested_at": requestedAt?.toIso8601String(),
    "verified_at": verifiedAt,
    "api_request": apiRequest,
    "api_response": apiResponse,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "reason": reason,
    "data_preference": dataPreference,
    "university_board": universityBoard,
    "college_school": collegeSchool,
  };
}
