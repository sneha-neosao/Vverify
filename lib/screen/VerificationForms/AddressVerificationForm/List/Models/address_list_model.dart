// To parse this JSON data, do
//
//     final addressListModel = addressListModelFromJson(jsonString);

import 'dart:convert';

AddressListModel addressListModelFromJson(String str) =>
    AddressListModel.fromJson(json.decode(str));

String addressListModelToJson(AddressListModel data) =>
    json.encode(data.toJson());

class AddressListModel {
  int? status;
  String? message;
  List<AddressDatum>? data;

  AddressListModel({
    this.status,
    this.message,
    this.data,
  });

  factory AddressListModel.fromJson(Map<String, dynamic> json) =>
      AddressListModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<AddressDatum>.from(
            json["data"]!.map((x) => AddressDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class AddressDatum {
  String? uid;
  int? requestId;
  int? serviceRequestId;
  String? caseUuid;
  String? addressUuid;
  String? currentAddressLine1;
  String? currentAddressLine2;
  String? currentAddressCity;
  String? currentAddressState;
  String? currentAddressPostalCode;
  String? permanentAddressLine1;
  String? permanentAddressLine2;
  String? permanentAddressCity;
  String? permanentAddressState;
  String? permanentAddressPostalCode;
  String? residingFromDate;
  String? residingToDate;
  String? vStatus;
  String? currentAddressVStatus;
  String? permanentAddressVStatus;
  String? verificationRemark;
  String? permanentAddressVerificationRemark;
  String? dataPreference;
  String? artefactImg;
  String? artefactLink;
  String? showOnReport;
  String? createdAt;
  String? updatedAt;

  AddressDatum({
    this.uid,
    this.requestId,
    this.serviceRequestId,
    this.caseUuid,
    this.addressUuid,
    this.currentAddressLine1,
    this.currentAddressLine2,
    this.currentAddressCity,
    this.currentAddressState,
    this.currentAddressPostalCode,
    this.permanentAddressLine1,
    this.permanentAddressLine2,
    this.permanentAddressCity,
    this.permanentAddressState,
    this.permanentAddressPostalCode,
    this.residingFromDate,
    this.residingToDate,
    this.vStatus,
    this.currentAddressVStatus,
    this.permanentAddressVStatus,
    this.verificationRemark,
    this.permanentAddressVerificationRemark,
    this.dataPreference,
    this.artefactImg,
    this.artefactLink,
    this.showOnReport,
    this.createdAt,
    this.updatedAt,
  });

  factory AddressDatum.fromJson(Map<String, dynamic> json) => AddressDatum(
    uid: json["uid"],
    requestId: json["request_id"],
    serviceRequestId: json["service_request_id"],
    caseUuid: json["case_uuid"],
    addressUuid: json["address_uuid"],
    currentAddressLine1: json["current_address_line_1"],
    currentAddressLine2: json["current_address_line_2"],
    currentAddressCity: json["current_address_city"],
    currentAddressState: json["current_address_state"],
    currentAddressPostalCode: json["current_address_postal_code"],
    permanentAddressLine1: json["permanent_address_line_1"],
    permanentAddressLine2: json["permanent_address_line_2"],
    permanentAddressCity: json["permanent_address_city"],
    permanentAddressState: json["permanent_address_state"],
    permanentAddressPostalCode: json["permanent_address_postal_code"],
    residingFromDate: json["residing_from_date"],
    residingToDate: json["residing_to_date"],
    vStatus: json["v_status"],
    currentAddressVStatus: json["current_address_v_status"],
    permanentAddressVStatus: json["permanent_address_v_status"],
    verificationRemark: json["verification_remark"],
    permanentAddressVerificationRemark:
    json["permanent_address_verification_remark"],
    dataPreference: json["data_preference"],
    artefactImg: json["artefact_img"],
    artefactLink: json["artefact_link"],
    showOnReport: json["show_on_report"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "request_id": requestId,
    "service_request_id": serviceRequestId,
    "case_uuid": caseUuid,
    "address_uuid": addressUuid,
    "current_address_line_1": currentAddressLine1,
    "current_address_line_2": currentAddressLine2,
    "current_address_city": currentAddressCity,
    "current_address_state": currentAddressState,
    "current_address_postal_code": currentAddressPostalCode,
    "permanent_address_line_1": permanentAddressLine1,
    "permanent_address_line_2": permanentAddressLine2,
    "permanent_address_city": permanentAddressCity,
    "permanent_address_state": permanentAddressState,
    "permanent_address_postal_code": permanentAddressPostalCode,
    "residing_from_date": residingFromDate,
    "residing_to_date": residingToDate,
    "v_status": vStatus,
    "current_address_v_status": currentAddressVStatus,
    "permanent_address_v_status": permanentAddressVStatus,
    "verification_remark": verificationRemark,
    "permanent_address_verification_remark": permanentAddressVerificationRemark,
    "data_preference": dataPreference,
    "artefact_img": artefactImg,
    "artefact_link": artefactLink,
    "show_on_report": showOnReport,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
