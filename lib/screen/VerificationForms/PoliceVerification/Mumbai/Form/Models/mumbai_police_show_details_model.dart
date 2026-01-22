// To parse this JSON data, do
//
//     final mumbaiShowDataModel = mumbaiShowDataModelFromJson(jsonString);

import 'dart:convert';

MumbaiShowDataModel mumbaiShowDataModelFromJson(String str) => MumbaiShowDataModel.fromJson(json.decode(str));

String mumbaiShowDataModelToJson(MumbaiShowDataModel data) => json.encode(data.toJson());

class MumbaiShowDataModel {
  int? status;
  String? message;
  Data? data;

  MumbaiShowDataModel({
    this.status,
    this.message,
    this.data,
  });

  factory MumbaiShowDataModel.fromJson(Map<String, dynamic> json) => MumbaiShowDataModel(
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
  int? serviceRequestId;
  int? requestId;
  String? status;
  int? policeStationId;
  String? rentedAddress;
  String? rentedCity;
  String? rentedState;
  String? rentedPostalCode;
  DateTime? agreementStartDate;
  DateTime? agreementEndDate;
  String? ownerFullName;
  String? ownerMobNo;
  String? ownerEmail;
  String? ownerAddress;
  String? ownerCityDistrict;
  String? ownerState;
  String? ownerPostalCode;
  String? ownerPhoto;
  String? tenantName;
  String? tenantAddress;
  String? tenantCity;
  String? tenantState;
  String? tenantPostalCode;
  String? tenantPhoto;
  String? tenantSignature;
  String? tenantIdentityProofDocType;
  String? tenantIdentityProofNo;
  String? tenantIdentityProofDoc;
  String? tenantCoResidentMalesNo;
  String? tenantCoResidentFemalesNo;
  String? tenantCoResidentChildrenNo;
  String? tenantWorkPhone;
  String? tenantWorkEmail;
  String? tenantOccupation;
  String? tenantWorkPlaceAddress;
  String? tenantWorkCity;
  String? tenantWorkState;
  String? tenantWorkPostalCode;
  String? tenantContactOneFullName;
  String? tenantContactOnePhone;
  String? tenantContactTwoFullName;
  String? tenantContactTwoPhone;
  String? agentName;
  String? agentDetails;
  String? dataDocument;
  String? reason;
  int? city_id;

  Data({
    this.id,
    this.uid,
    this.serviceRequestId,
    this.requestId,
    this.status,
    this.policeStationId,
    this.rentedAddress,
    this.rentedCity,
    this.rentedState,
    this.rentedPostalCode,
    this.agreementStartDate,
    this.agreementEndDate,
    this.ownerFullName,
    this.ownerMobNo,
    this.ownerEmail,
    this.ownerAddress,
    this.ownerCityDistrict,
    this.ownerState,
    this.ownerPostalCode,
    this.ownerPhoto,
    this.tenantName,
    this.tenantAddress,
    this.tenantCity,
    this.tenantState,
    this.tenantPostalCode,
    this.tenantPhoto,
    this.tenantSignature,
    this.tenantIdentityProofDocType,
    this.tenantIdentityProofNo,
    this.tenantIdentityProofDoc,
    this.tenantCoResidentMalesNo,
    this.tenantCoResidentFemalesNo,
    this.tenantCoResidentChildrenNo,
    this.tenantWorkPhone,
    this.tenantWorkEmail,
    this.tenantOccupation,
    this.tenantWorkPlaceAddress,
    this.tenantWorkCity,
    this.tenantWorkState,
    this.tenantWorkPostalCode,
    this.tenantContactOneFullName,
    this.tenantContactOnePhone,
    this.tenantContactTwoFullName,
    this.tenantContactTwoPhone,
    this.agentName,
    this.agentDetails,
    this.dataDocument,
    this.reason,
    this.city_id
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    uid: json["uid"],
    serviceRequestId: json["service_request_id"],
    requestId: json["request_id"],
    status: json["status"],
    policeStationId: json["police_station_id"],
    rentedAddress: json["rented_address"],
    rentedCity: json["rented_city"],
    rentedState: json["rented_state"],
    rentedPostalCode: json["rented_postal_code"],
    agreementStartDate: json["agreement_start_date"] == null ? null : DateTime.parse(json["agreement_start_date"]),
    agreementEndDate: json["agreement_end_date"] == null ? null : DateTime.parse(json["agreement_end_date"]),
    ownerFullName: json["owner_full_name"],
    ownerMobNo: json["owner_mob_no"],
    ownerEmail: json["owner_email"],
    ownerAddress: json["owner_address"],
    ownerCityDistrict: json["owner_city_district"],
    ownerState: json["owner_state"],
    ownerPostalCode: json["owner_postal_code"],
    ownerPhoto: json["owner_photo"],
    tenantName: json["tenant_name"],
    tenantAddress: json["tenant_address"],
    tenantCity: json["tenant_city"],
    tenantState: json["tenant_state"],
    tenantPostalCode: json["tenant_postal_code"],
    tenantPhoto: json["tenant_photo"],
    tenantSignature: json["tenant_signature"],
    tenantIdentityProofDocType: json["tenant_identity_proof_doc_type"],
    tenantIdentityProofNo: json["tenant_identity_proof_no"],
    tenantIdentityProofDoc: json["tenant_identity_proof_doc"],
    tenantCoResidentMalesNo: json["tenant_co_resident_males_no"],
    tenantCoResidentFemalesNo: json["tenant_co_resident_females_no"],
    tenantCoResidentChildrenNo: json["tenant_co_resident_children_no"],
    tenantWorkPhone: json["tenant_work_phone"],
    tenantWorkEmail: json["tenant_work_email"],
    tenantOccupation: json["tenant_occupation"],
    tenantWorkPlaceAddress: json["tenant_work_place_address"],
    tenantWorkCity: json["tenant_work_city"],
    tenantWorkState: json["tenant_work_state"],
    tenantWorkPostalCode: json["tenant_work_postal_code"],
    tenantContactOneFullName: json["tenant_contact_one_full_name"],
    tenantContactOnePhone: json["tenant_contact_one_phone"],
    tenantContactTwoFullName: json["tenant_contact_two_full_name"],
    tenantContactTwoPhone: json["tenant_contact_two_phone"],
    agentName: json["agent_name"],
    agentDetails: json["agent_details"],
    dataDocument: json["data_document"],
    reason: json["reason"],
    city_id: json["city_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "uid": uid,
    "service_request_id": serviceRequestId,
    "request_id": requestId,
    "status": status,
    "police_station_id": policeStationId,
    "rented_address": rentedAddress,
    "rented_city": rentedCity,
    "rented_state": rentedState,
    "rented_postal_code": rentedPostalCode,
    "agreement_start_date": agreementStartDate?.toIso8601String(),
    "agreement_end_date": agreementEndDate?.toIso8601String(),
    "owner_full_name": ownerFullName,
    "owner_mob_no": ownerMobNo,
    "owner_email": ownerEmail,
    "owner_address": ownerAddress,
    "owner_city_district": ownerCityDistrict,
    "owner_state": ownerState,
    "owner_postal_code": ownerPostalCode,
    "owner_photo": ownerPhoto,
    "tenant_name": tenantName,
    "tenant_address": tenantAddress,
    "tenant_city": tenantCity,
    "tenant_state": tenantState,
    "tenant_postal_code": tenantPostalCode,
    "tenant_photo": tenantPhoto,
    "tenant_signature": tenantSignature,
    "tenant_identity_proof_doc_type": tenantIdentityProofDocType,
    "tenant_identity_proof_no": tenantIdentityProofNo,
    "tenant_identity_proof_doc": tenantIdentityProofDoc,
    "tenant_co_resident_males_no": tenantCoResidentMalesNo,
    "tenant_co_resident_females_no": tenantCoResidentFemalesNo,
    "tenant_co_resident_children_no": tenantCoResidentChildrenNo,
    "tenant_work_phone": tenantWorkPhone,
    "tenant_work_email": tenantWorkEmail,
    "tenant_occupation": tenantOccupation,
    "tenant_work_place_address": tenantWorkPlaceAddress,
    "tenant_work_city": tenantWorkCity,
    "tenant_work_state": tenantWorkState,
    "tenant_work_postal_code": tenantWorkPostalCode,
    "tenant_contact_one_full_name": tenantContactOneFullName,
    "tenant_contact_one_phone": tenantContactOnePhone,
    "tenant_contact_two_full_name": tenantContactTwoFullName,
    "tenant_contact_two_phone": tenantContactTwoPhone,
    "agent_name": agentName,
    "agent_details": agentDetails,
    "data_document": dataDocument,
    "reason": reason,
    "city_id": city_id,
  };
}
