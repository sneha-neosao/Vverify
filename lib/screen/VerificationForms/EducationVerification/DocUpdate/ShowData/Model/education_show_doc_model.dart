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
  int? caseId;
  int? educationId;
  int? requestId;
  int? serviceRequestId;
  String? universityName;
  String? institutionName;
  int? yearOfPassing;
  String? degreeQualificationName;
  String? gradesType;
  String? gradesObtained;
  int? createdBy;
  int? screenedBy;
  int? verifiedBy;
  String? vStatus;
  String? universityNameVStatus;
  String? passingYearVStatus;
  String? institutionNameVStatus;
  String? degreeNameVStatus;
  String? verificationRemark;
  String? artefactImg;
  String? artefactLink;
  bool? showOnReport;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? dataPreference;
  String? document;

  Data({
    this.id,
    this.uid,
    this.caseId,
    this.educationId,
    this.requestId,
    this.serviceRequestId,
    this.universityName,
    this.institutionName,
    this.yearOfPassing,
    this.degreeQualificationName,
    this.gradesType,
    this.gradesObtained,
    this.createdBy,
    this.screenedBy,
    this.verifiedBy,
    this.vStatus,
    this.universityNameVStatus,
    this.passingYearVStatus,
    this.institutionNameVStatus,
    this.degreeNameVStatus,
    this.verificationRemark,
    this.artefactImg,
    this.artefactLink,
    this.showOnReport,
    this.createdAt,
    this.updatedAt,
    this.dataPreference,
    this.document,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
      id: json["id"],
      uid: json["uid"],
      caseId: json["case_id"],
      educationId: json["education_id"],
      requestId: json["request_id"],
      serviceRequestId: json["service_request_id"],
      universityName: json["university_name"],
      institutionName: json["institution_name"],
      yearOfPassing: json["year_of_passing"],
      degreeQualificationName: json["degree_qualification_name"],
      gradesType: json["grades_type"],
      gradesObtained: json["grades_obtained"],
      createdBy: json["created_by"],
      screenedBy: json["screened_by"],
      verifiedBy: json["verified_by"],
      vStatus: json["v_status"],
      universityNameVStatus: json["university_name_v_status"],
      passingYearVStatus: json["passing_year_v_status"],
      institutionNameVStatus: json["institution_name_v_status"],
      degreeNameVStatus: json["degree_name_v_status"],
      verificationRemark: json["verification_remark"],
      artefactImg: json["artefact_img"],
      artefactLink: json["artefact_link"],
      showOnReport: json["show_on_report"] ?? false,
      createdAt: json["created_at"] == null
          ? null
          : DateTime.parse(json["created_at"]),
      updatedAt: json["updated_at"] == null
          ? null
          : DateTime.parse(json["updated_at"]),
      dataPreference: json["data_preference"],
      document: json["document"]
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "uid": uid,
    "case_id": caseId,
    "education_id": educationId,
    "request_id": requestId,
    "service_request_id": serviceRequestId,
    "university_name": universityName,
    "institution_name": institutionName,
    "year_of_passing": yearOfPassing,
    "degree_qualification_name": degreeQualificationName,
    "grades_type": gradesType,
    "grades_obtained": gradesObtained,
    "created_by": createdBy,
    "screened_by": screenedBy,
    "verified_by": verifiedBy,
    "v_status": vStatus,
    "university_name_v_status": universityNameVStatus,
    "passing_year_v_status": passingYearVStatus,
    "institution_name_v_status": institutionNameVStatus,
    "degree_name_v_status": degreeNameVStatus,
    "verification_remark": verificationRemark,
    "artefact_img": artefactImg,
    "artefact_link": artefactLink,
    "show_on_report": showOnReport,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "data_preference": dataPreference,
    "document": document
  };
}
