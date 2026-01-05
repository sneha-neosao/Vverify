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
  String? case_id;
  int? request_id;
  int? service_request_id;
  int? employment_id;
  String? employer_name;          // employer_name
  String? employed_from;          // employed_from
  String? employed_to;             // employed_to
  String? designation;             // designation
  String? department;
  String? remunaration;               // remunaration
  String? reporting_manager;        // reporting_manager
  String? reason_for_leaving;
  String? eligible_for_rehire;
  String? mentioned_issues;
  String? reason_for_leaving_status;
  String? v_status;               // v_status
  String? verification_remark;
  String? data_preference;
  String? artefact_img;
  String? artefact_link;
  String? employment_supporting_doc;
  int? show_on_report;
  String? created_at;
  String? updated_at;

  Datum({
    this.uid,
    this.case_id,
    this.request_id,
    this.service_request_id,
    this.employment_id,
    this.employer_name,
    this.employed_from,
    this.employed_to,
    this.designation,
    this.department,
    this.remunaration,
    this.reporting_manager,
    this.reason_for_leaving,
    this.eligible_for_rehire,
    this.mentioned_issues,
    this.reason_for_leaving_status,
    this.v_status,
    this.verification_remark,
    this.data_preference,
    this.artefact_img,
    this.artefact_link,
    this.employment_supporting_doc,
    this.show_on_report,
    this.created_at,
    this.updated_at,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    uid: json["uid"],
    case_id: json["case_id"],
    request_id: json["request_id"],
    service_request_id: json["service_request_id"],
    employment_id: json["employment_id"],
    employer_name: json["employer_name"],
    employed_from: json["employed_from"],
    employed_to: json["employed_to"],
    designation: json["designation"],
    department: json["department"],
    remunaration: json["remunaration"],
    reporting_manager: json["reporting_manager"],
    reason_for_leaving: json["reason_for_leaving"],
    eligible_for_rehire: json["eligible_for_rehire"],
    mentioned_issues: json["mentioned_issues"],
    reason_for_leaving_status: json["reason_for_leaving_status"],
    v_status: json["v_status"],
    verification_remark: json["verification_remark"],
    data_preference: json["data_preference"],
    artefact_img: json["artefact_img"],
    artefact_link: json["artefact_link"],
    employment_supporting_doc: json["employment_supporting_doc"],
    show_on_report: json["show_on_report"],
    created_at: json["created_at"],
    updated_at: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "case_id": case_id,
    "request_id": request_id,
    "service_request_id": service_request_id,
    "employment_id": employment_id,
    "employer_name": employer_name,
    "employed_from": employed_from,
    "employed_to": employed_to,
    "designation": designation,
    "department": department,
    "remunaration": remunaration,
    "reporting_manager": reporting_manager,
    "reason_for_leaving": reason_for_leaving,
    "eligible_for_rehire": eligible_for_rehire,
    "mentioned_issues": mentioned_issues,
    "reason_for_leaving_status": reason_for_leaving_status,
    "v_status": v_status,
    "verification_remark": verification_remark,
    "data_preference": data_preference,
    "artefact_img": artefact_img,
    "artefact_link": artefact_link,
    "employment_supporting_doc": employment_supporting_doc,
    "show_on_report": show_on_report,
    "created_at": created_at,
    "updated_at": updated_at,
  };
}
