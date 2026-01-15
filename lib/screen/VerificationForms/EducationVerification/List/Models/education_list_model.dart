// To parse this JSON data, do
//
//     final educationDocListModel = educationDocListModelFromJson(jsonString);

import 'dart:convert';

EducationDocListModel educationDocListModelFromJson(String str) => EducationDocListModel.fromJson(json.decode(str));

String educationDocListModelToJson(EducationDocListModel data) => json.encode(data.toJson());

class EducationDocListModel {
  int? status;
  String? message;
  List<Datum>? data;

  EducationDocListModel({
    this.status,
    this.message,
    this.data,
  });

  factory EducationDocListModel.fromJson(Map<String, dynamic> json) => EducationDocListModel(
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
  int? request_id;
  int? service_request_id;
  String? university_name;
  String? institution_name;
  String? year_of_passing;
  String? degree_qualification_name;
  String? grades_type;
  String? grades_obtained;
  String? artefact_img;
  String? artefact_link;
  String? v_status;
  String? university_name_v_status;
  String? passing_year_v_status;
  String? institution_name_v_status;
  String? degree_name_v_status;
  String? verification_remark;
  String? data_preference;
  String? document;
  String? created_at;
  String? updated_at;
  String? case_uuid;
  String? education_uuid;

  Datum({
    this.uid,
    this.request_id,
    this.service_request_id,
    this.university_name,
    this.institution_name,
    this.year_of_passing,
    this.degree_qualification_name,
    this.grades_type,
    this.grades_obtained,
    this.artefact_img,
    this.artefact_link,
    this.v_status,
    this.university_name_v_status,
    this.passing_year_v_status,
    this.institution_name_v_status,
    this.degree_name_v_status,
    this.verification_remark,
    this.data_preference,
    this.document,
    this.created_at,
    this.updated_at,
    this.case_uuid,
    this.education_uuid
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    uid: json["uid"],
    request_id: json["request_id"],
    service_request_id: json["service_request_id"],
    university_name: json["university_name"],
    institution_name: json["institution_name"],
    year_of_passing: json["year_of_passing"]?.toString(),
    degree_qualification_name: json["degree_qualification_name"],
    grades_type: json["grades_type"],
    grades_obtained: json["grades_obtained"],
    artefact_img: json["artefact_img"],
    artefact_link: json["artefact_link"],
    v_status: json["v_status"],
    university_name_v_status: json["university_name_v_status"],
    passing_year_v_status: json["passing_year_v_status"],
    institution_name_v_status: json["institution_name_v_status"],
    degree_name_v_status: json["degree_name_v_status"],
    verification_remark: json["verification_remark"],
    data_preference: json["data_preference"],
    document: json["document"],
    created_at: json["created_at"],
    updated_at: json["updated_at"],
    case_uuid: json["case_uuid"],
    education_uuid: json["education_uuid"]
  );

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "request_id": request_id,
    "service_request_id": service_request_id,
    "university_name": university_name,
    "institution_name": institution_name,
    "year_of_passing": year_of_passing,
    "degree_qualification_name": degree_qualification_name,
    "grades_type": grades_type,
    "grades_obtained": grades_obtained,
    "artefact_img": artefact_img,
    "artefact_link": artefact_link,
    "v_status": v_status,
    "university_name_v_status": university_name_v_status,
    "passing_year_v_status": passing_year_v_status,
    "institution_name_v_status": institution_name_v_status,
    "degree_name_v_status": degree_name_v_status,
    "verification_remark": verification_remark,
    "data_preference": data_preference,
    "document": document,
    "created_at": created_at,
    "updated_at": updated_at,
    "case_uuid": case_uuid,
    "education_uuid": education_uuid
  };

}
