// To parse this JSON data, do
//
//     final nonMumbaiDocShowDataModel = nonMumbaiDocShowDataModelFromJson(jsonString);

import 'dart:convert';

NonMumbaiDocShowDataModel nonMumbaiDocShowDataModelFromJson(String str) => NonMumbaiDocShowDataModel.fromJson(json.decode(str));

String nonMumbaiDocShowDataModelToJson(NonMumbaiDocShowDataModel data) => json.encode(data.toJson());

class NonMumbaiDocShowDataModel {
  int? status;
  String? message;
  Data? data;

  NonMumbaiDocShowDataModel({
    this.status,
    this.message,
    this.data,
  });

  factory NonMumbaiDocShowDataModel.fromJson(Map<String, dynamic> json) => NonMumbaiDocShowDataModel(
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
  String? uid;
  int? requestId;
  int? serviceRequestId;
  dynamic tenantName;
  dynamic tenantAddress;
  dynamic tenantCity;
  dynamic tenantState;
  dynamic tenantPostalCode;
  dynamic tenantDob;
  dynamic tenantBirthPlace;
  dynamic tenantAge;
  dynamic tenantFathersName;
  dynamic tenantFathersAddress;
  dynamic tenantFathersOccupation;
  int? tenantIsEmployed;
  dynamic tenantEmployerOrCompany;
  dynamic tenantEmployedYear;
  dynamic tenantEmployedMonth;
  dynamic tenantIdentificationMark;
  bool? tenantHasCriminalOffenses;
  dynamic tenantCrnoSection;
  int? tenantWhetherArrested;
  dynamic tenantPresentCaseStatus;
  dynamic tenantContactOneFullName;
  dynamic tenantContactOneAddress;
  dynamic tenantContactTwoFullName;
  dynamic tenantContactTwoAddress;
  dynamic tenantEarlierResidentialPlace;
  String? tenantEarlierResidentialYears;
  int? tenantEarlierResidentialMonths;
  dynamic tenantEarlierResidentialJurisdictionOfPoliceStation;
  dynamic tenantJurisdictionOfPoliceStation;
  String? tenantPresentAddressDurationYears;
  int? tenantPresentAddressDurationMonths;
  dynamic tenantSignaturePlace;
  dynamic tenantSignatureDate;
  String? tenantSignature;
  dynamic tenantIdentityProofDocType;
  dynamic tenantIdentityProofNo;
  String? tenantIdentityProofDoc;
  String? tenantLetterFromEmployer;
  String? tenantPhoto;
  String? dataDocument;
  String? reason;

  Data({
    this.uid,
    this.requestId,
    this.serviceRequestId,
    this.tenantName,
    this.tenantAddress,
    this.tenantCity,
    this.tenantState,
    this.tenantPostalCode,
    this.tenantDob,
    this.tenantBirthPlace,
    this.tenantAge,
    this.tenantFathersName,
    this.tenantFathersAddress,
    this.tenantFathersOccupation,
    this.tenantIsEmployed,
    this.tenantEmployerOrCompany,
    this.tenantEmployedYear,
    this.tenantEmployedMonth,
    this.tenantIdentificationMark,
    this.tenantHasCriminalOffenses,
    this.tenantCrnoSection,
    this.tenantWhetherArrested,
    this.tenantPresentCaseStatus,
    this.tenantContactOneFullName,
    this.tenantContactOneAddress,
    this.tenantContactTwoFullName,
    this.tenantContactTwoAddress,
    this.tenantEarlierResidentialPlace,
    this.tenantEarlierResidentialYears,
    this.tenantEarlierResidentialMonths,
    this.tenantEarlierResidentialJurisdictionOfPoliceStation,
    this.tenantJurisdictionOfPoliceStation,
    this.tenantPresentAddressDurationYears,
    this.tenantPresentAddressDurationMonths,
    this.tenantSignaturePlace,
    this.tenantSignatureDate,
    this.tenantSignature,
    this.tenantIdentityProofDocType,
    this.tenantIdentityProofNo,
    this.tenantIdentityProofDoc,
    this.tenantLetterFromEmployer,
    this.tenantPhoto,
    this.dataDocument,
    this.reason,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    uid: json["uid"],
    requestId: json["request_id"],
    serviceRequestId: json["service_request_id"],
    tenantName: json["tenant_name"],
    tenantAddress: json["tenant_address"],
    tenantCity: json["tenant_city"],
    tenantState: json["tenant_state"],
    tenantPostalCode: json["tenant_postal_code"],
    tenantDob: json["tenant_dob"],
    tenantBirthPlace: json["tenant_birth_place"],
    tenantAge: json["tenant_age"],
    tenantFathersName: json["tenant_fathers_name"],
    tenantFathersAddress: json["tenant_fathers_address"],
    tenantFathersOccupation: json["tenant_fathers_occupation"],
    tenantIsEmployed: json["tenant_is_employed"],
    tenantEmployerOrCompany: json["tenant_employer_or_company"],
    tenantEmployedYear: json["tenant_employed_year"],
    tenantEmployedMonth: json["tenant_employed_month"],
    tenantIdentificationMark: json["tenant_identification_mark"],
    tenantHasCriminalOffenses: json["tenant_has_criminal_offenses"],
    tenantCrnoSection: json["tenant_crno_section"],
    tenantWhetherArrested: json["tenant_whether_arrested"],
    tenantPresentCaseStatus: json["tenant_present_case_status"],
    tenantContactOneFullName: json["tenant_contact_one_full_name"],
    tenantContactOneAddress: json["tenant_contact_one_address"],
    tenantContactTwoFullName: json["tenant_contact_two_full_name"],
    tenantContactTwoAddress: json["tenant_contact_two_address"],
    tenantEarlierResidentialPlace: json["tenant_earlier_residential_place"],
    tenantEarlierResidentialYears: json["tenant_earlier_residential_years"],
    tenantEarlierResidentialMonths: json["tenant_earlier_residential_months"],
    tenantEarlierResidentialJurisdictionOfPoliceStation: json["tenant_earlier_residential_jurisdiction_of_police_station"],
    tenantJurisdictionOfPoliceStation: json["tenant_jurisdiction_of_police_station"],
    tenantPresentAddressDurationYears: json["tenant_present_address_duration_years"],
    tenantPresentAddressDurationMonths: json["tenant_present_address_duration_months"],
    tenantSignaturePlace: json["tenant_signature_place"],
    tenantSignatureDate: json["tenant_signature_date"],
    tenantSignature: json["tenant_signature"],
    tenantIdentityProofDocType: json["tenant_identity_proof_doc_type"],
    tenantIdentityProofNo: json["tenant_identity_proof_no"],
    tenantIdentityProofDoc: json["tenant_identity_proof_doc"],
    tenantLetterFromEmployer: json["tenant_letter_from_employer"],
    tenantPhoto: json["tenant_photo"],
    dataDocument: json["data_document"],
    reason: json["reason"],
  );

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "request_id": requestId,
    "service_request_id": serviceRequestId,
    "tenant_name": tenantName,
    "tenant_address": tenantAddress,
    "tenant_city": tenantCity,
    "tenant_state": tenantState,
    "tenant_postal_code": tenantPostalCode,
    "tenant_dob": tenantDob,
    "tenant_birth_place": tenantBirthPlace,
    "tenant_age": tenantAge,
    "tenant_fathers_name": tenantFathersName,
    "tenant_fathers_address": tenantFathersAddress,
    "tenant_fathers_occupation": tenantFathersOccupation,
    "tenant_is_employed": tenantIsEmployed,
    "tenant_employer_or_company": tenantEmployerOrCompany,
    "tenant_employed_year": tenantEmployedYear,
    "tenant_employed_month": tenantEmployedMonth,
    "tenant_identification_mark": tenantIdentificationMark,
    "tenant_has_criminal_offenses": tenantHasCriminalOffenses,
    "tenant_crno_section": tenantCrnoSection,
    "tenant_whether_arrested": tenantWhetherArrested,
    "tenant_present_case_status": tenantPresentCaseStatus,
    "tenant_contact_one_full_name": tenantContactOneFullName,
    "tenant_contact_one_address": tenantContactOneAddress,
    "tenant_contact_two_full_name": tenantContactTwoFullName,
    "tenant_contact_two_address": tenantContactTwoAddress,
    "tenant_earlier_residential_place": tenantEarlierResidentialPlace,
    "tenant_earlier_residential_years": tenantEarlierResidentialYears,
    "tenant_earlier_residential_months": tenantEarlierResidentialMonths,
    "tenant_earlier_residential_jurisdiction_of_police_station": tenantEarlierResidentialJurisdictionOfPoliceStation,
    "tenant_jurisdiction_of_police_station": tenantJurisdictionOfPoliceStation,
    "tenant_present_address_duration_years": tenantPresentAddressDurationYears,
    "tenant_present_address_duration_months": tenantPresentAddressDurationMonths,
    "tenant_signature_place": tenantSignaturePlace,
    "tenant_signature_date": tenantSignatureDate,
    "tenant_signature": tenantSignature,
    "tenant_identity_proof_doc_type": tenantIdentityProofDocType,
    "tenant_identity_proof_no": tenantIdentityProofNo,
    "tenant_identity_proof_doc": tenantIdentityProofDoc,
    "tenant_letter_from_employer": tenantLetterFromEmployer,
    "tenant_photo": tenantPhoto,
    "data_document": dataDocument,
    "reason": reason,
  };
}
