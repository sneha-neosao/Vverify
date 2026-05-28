import 'dart:convert';

EducationListModel educationListModelFromJson(String str) =>
    EducationListModel.fromJson(json.decode(str));

String educationListModelToJson(EducationListModel data) =>
    json.encode(data.toJson());

class EducationListModel {
  int? status;
  String? message;
  List<EducationDatum>? data;

  EducationListModel({
    this.status,
    this.message,
    this.data,
  });

  factory EducationListModel.fromJson(Map<String, dynamic> json) =>
      EducationListModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<EducationDatum>.from(
                json["data"]!.map((x) => EducationDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class EducationDatum {
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
  String? createdAt;
  String? updatedAt;
  String? dataPreference;
  String? document;
  String? caseUuid;
  String? educationUuid;

  EducationDatum({
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
    this.caseUuid,
    this.educationUuid,
  });

  factory EducationDatum.fromJson(Map<String, dynamic> json) => EducationDatum(
        id: json["id"],
        uid: json["uid"],
        caseId: json["case_id"],
        educationId: json["education_id"],
        requestId: json["request_id"],
        serviceRequestId: json["service_request_id"],
        universityName: json["university_name"],
        institutionName: json["institution_name"],
        yearOfPassing: json["year_of_passing"] is int
            ? json["year_of_passing"]
            : int.tryParse(json["year_of_passing"]?.toString() ?? ""),
        degreeQualificationName: json["degree_qualification_name"],
        gradesType: json["grades_type"],
        gradesObtained: json["grades_obtained"]?.toString(),
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
        showOnReport: json["show_on_report"] is bool
            ? json["show_on_report"]
            : (json["show_on_report"] == 1 ||
                json["show_on_report"] == "1" ||
                json["show_on_report"] == true),
        createdAt: json["created_at"]?.toString(),
        updatedAt: json["updated_at"]?.toString(),
        dataPreference: json["data_preference"],
        document: json["document"],
        caseUuid: json["case_uuid"],
        educationUuid: json["education_uuid"],
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
        "created_at": createdAt,
        "updated_at": updatedAt,
        "data_preference": dataPreference,
        "document": document,
        "case_uuid": caseUuid,
        "education_uuid": educationUuid,
      };
}
