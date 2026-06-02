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
  int? request_id;
  int? service_request_id;
  String? employer_name;
  String? employed_from;
  String? employed_to;
  String? designation;
  String? remunaration;
  String? reporting_manager;
  String? reason_for_leaving;
  String? eligible_for_rehire;
  String? mentioned_issues;
  String? reason_for_leaving_status;
  int? created_by;
  int? screened_by;
  int? verified_by;
  String? verifier_name;
  String? data_preference;
  String? v_status;
  String? university_name_v_status;
  String? passing_year_v_status;
  String? institution_name_v_status;
  String? degree_name_v_status;
  String? verification_remark;
  String? artefact_img;
  String? artefact_link;
  int? show_on_report;
  String? created_at;
  String? updated_at;
  String? department;
  String? case_uuid;
  String? employment_uuid;
  String? employment_supporting_doc;

  Data({
    this.id,
    this.uid,
    this.request_id,
    this.service_request_id,
    this.employer_name,
    this.employed_from,
    this.employed_to,
    this.designation,
    this.remunaration,
    this.reporting_manager,
    this.reason_for_leaving,
    this.eligible_for_rehire,
    this.mentioned_issues,
    this.reason_for_leaving_status,
    this.created_by,
    this.screened_by,
    this.verified_by,
    this.verifier_name,
    this.data_preference,
    this.v_status,
    this.university_name_v_status,
    this.passing_year_v_status,
    this.institution_name_v_status,
    this.degree_name_v_status,
    this.verification_remark,
    this.artefact_img,
    this.artefact_link,
    this.show_on_report,
    this.created_at,
    this.updated_at,
    this.department,
    this.case_uuid,
    this.employment_uuid,
    this.employment_supporting_doc,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        uid: json["uid"],
        request_id: json["request_id"],
        service_request_id: json["service_request_id"],
        employer_name: json["employer_name"],
        employed_from: json["employed_from"],
        employed_to: json["employed_to"],
        designation: json["designation"],
        remunaration: json["remunaration"],
        reporting_manager: json["reporting_manager"],
        reason_for_leaving: json["reason_for_leaving"],
        eligible_for_rehire: json["eligible_for_rehire"],
        mentioned_issues: json["mentioned_issues"],
        reason_for_leaving_status: json["reason_for_leaving_status"],
        created_by: json["created_by"],
        screened_by: json["screened_by"],
        verified_by: json["verified_by"],
        verifier_name: json["verifier_name"],
        data_preference: json["data_preference"],
        v_status: json["v_status"],
        university_name_v_status: json["university_name_v_status"],
        passing_year_v_status: json["passing_year_v_status"],
        institution_name_v_status: json["institution_name_v_status"],
        degree_name_v_status: json["degree_name_v_status"],
        verification_remark: json["verification_remark"],
        artefact_img: json["artefact_img"],
        artefact_link: json["artefact_link"],
        show_on_report: json["show_on_report"],
        created_at: json["created_at"],
        updated_at: json["updated_at"],
        department: json["department"],
        case_uuid: json["case_uuid"],
        employment_uuid: json["employment_uuid"],
        employment_supporting_doc: json["employment_supporting_doc"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "uid": uid,
        "request_id": request_id,
        "service_request_id": service_request_id,
        "employer_name": employer_name,
        "employed_from": employed_from,
        "employed_to": employed_to,
        "designation": designation,
        "remunaration": remunaration,
        "reporting_manager": reporting_manager,
        "reason_for_leaving": reason_for_leaving,
        "eligible_for_rehire": eligible_for_rehire,
        "mentioned_issues": mentioned_issues,
        "reason_for_leaving_status": reason_for_leaving_status,
        "created_by": created_by,
        "screened_by": screened_by,
        "verified_by": verified_by,
        "verifier_name": verifier_name,
        "data_preference": data_preference,
        "v_status": v_status,
        "university_name_v_status": university_name_v_status,
        "passing_year_v_status": passing_year_v_status,
        "institution_name_v_status": institution_name_v_status,
        "degree_name_v_status": degree_name_v_status,
        "verification_remark": verification_remark,
        "artefact_img": artefact_img,
        "artefact_link": artefact_link,
        "show_on_report": show_on_report,
        "created_at": created_at,
        "updated_at": updated_at,
        "department": department,
        "case_uuid": case_uuid,
        "employment_uuid": employment_uuid,
        "employment_supporting_doc": employment_supporting_doc,
      };
}
