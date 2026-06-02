// To parse this JSON data, do
//
//     final nameAddressShowDataModel = nameAddressShowDataModelFromJson(jsonString);

import 'dart:convert';

NameAddressShowDataModel nameAddressShowDataModelFromJson(String str) =>
    NameAddressShowDataModel.fromJson(json.decode(str));

String nameAddressShowDataModelToJson(NameAddressShowDataModel data) =>
    json.encode(data.toJson());

class NameAddressShowDataModel {
  int? status;
  Data? data;

  NameAddressShowDataModel({
    this.status,
    this.data,
  });

  factory NameAddressShowDataModel.fromJson(Map<String, dynamic> json) =>
      NameAddressShowDataModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
      };
}

class Data {
  int? id;
  String? uid;
  int? request_id;
  int? service_request_id;
  String? case_uuid;
  String? address_uuid;
  String? current_address_line_1;
  String? current_address_line_2;
  String? current_address_city;
  String? current_address_state;
  String? current_address_postal_code;
  String? permanent_address_line_1;
  String? permanent_address_line_2;
  String? permanent_address_city;
  String? permanent_address_state;
  String? permanent_address_postal_code;
  String? residing_from_date;
  String? residing_to_date;
  int? created_by;
  int? screened_by;
  String? v_status;
  String? current_address_v_status;
  String? permanent_address_v_status;
  String? verified_by;
  String? verification_remark;
  String? artefact_img;
  String? artefact_link;
  String? show_on_report;
  String? permanent_address_verified_by;
  String? permanent_address_verification_remark;
  String? data_preference;
  String? created_at;
  String? updated_at;

  Data({
    this.id,
    this.uid,
    this.request_id,
    this.service_request_id,
    this.case_uuid,
    this.address_uuid,
    this.current_address_line_1,
    this.current_address_line_2,
    this.current_address_city,
    this.current_address_state,
    this.current_address_postal_code,
    this.permanent_address_line_1,
    this.permanent_address_line_2,
    this.permanent_address_city,
    this.permanent_address_state,
    this.permanent_address_postal_code,
    this.residing_from_date,
    this.residing_to_date,
    this.created_by,
    this.screened_by,
    this.v_status,
    this.current_address_v_status,
    this.permanent_address_v_status,
    this.verified_by,
    this.verification_remark,
    this.artefact_img,
    this.artefact_link,
    this.show_on_report,
    this.permanent_address_verified_by,
    this.permanent_address_verification_remark,
    this.data_preference,
    this.created_at,
    this.updated_at,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        uid: json["uid"],
        request_id: json["request_id"],
        service_request_id: json["service_request_id"],
        case_uuid: json["case_uuid"],
        address_uuid: json["address_uuid"],
        current_address_line_1: json["current_address_line_1"],
        current_address_line_2: json["current_address_line_2"],
        current_address_city: json["current_address_city"],
        current_address_state: json["current_address_state"],
        current_address_postal_code: json["current_address_postal_code"],
        permanent_address_line_1: json["permanent_address_line_1"],
        permanent_address_line_2: json["permanent_address_line_2"],
        permanent_address_city: json["permanent_address_city"],
        permanent_address_state: json["permanent_address_state"],
        permanent_address_postal_code: json["permanent_address_postal_code"],
        residing_from_date: json["residing_from_date"],
        residing_to_date: json["residing_to_date"],
        created_by: json["created_by"],
        screened_by: json["screened_by"],
        v_status: json["v_status"],
        current_address_v_status: json["current_address_v_status"],
        permanent_address_v_status: json["permanent_address_v_status"],
        verified_by: json["verified_by"],
        verification_remark: json["verification_remark"],
        artefact_img: json["artefact_img"],
        artefact_link: json["artefact_link"],
        show_on_report: json["show_on_report"],
        permanent_address_verified_by: json["permanent_address_verified_by"],
        permanent_address_verification_remark:
            json["permanent_address_verification_remark"],
        data_preference: json["data_preference"],
        created_at: json["created_at"],
        updated_at: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "uid": uid,
        "request_id": request_id,
        "service_request_id": service_request_id,
        "case_uuid": case_uuid,
        "address_uuid": address_uuid,
        "current_address_line_1": current_address_line_1,
        "current_address_line_2": current_address_line_2,
        "current_address_city": current_address_city,
        "current_address_state": current_address_state,
        "current_address_postal_code": current_address_postal_code,
        "permanent_address_line_1": permanent_address_line_1,
        "permanent_address_line_2": permanent_address_line_2,
        "permanent_address_city": permanent_address_city,
        "permanent_address_state": permanent_address_state,
        "permanent_address_postal_code": permanent_address_postal_code,
        "residing_from_date": residing_from_date,
        "residing_to_date": residing_to_date,
        "created_by": created_by,
        "screened_by": screened_by,
        "v_status": v_status,
        "current_address_v_status": current_address_v_status,
        "permanent_address_v_status": permanent_address_v_status,
        "verified_by": verified_by,
        "verification_remark": verification_remark,
        "artefact_img": artefact_img,
        "artefact_link": artefact_link,
        "show_on_report": show_on_report,
        "permanent_address_verified_by": permanent_address_verified_by,
        "permanent_address_verification_remark":
            permanent_address_verification_remark,
        "data_preference": data_preference,
        "created_at": created_at,
        "updated_at": updated_at,
      };
}
