import 'dart:convert';

PanVerificationSubmitModel panVerificationSubmitModelFromJson(String str) =>
    PanVerificationSubmitModel.fromJson(json.decode(str));

String panVerificationSubmitModelToJson(PanVerificationSubmitModel data) =>
    json.encode(data.toJson());

class PanVerificationSubmitModel {
  int? status;
  String? message;
  SubmitData? data;
  String? uid;
  String? pdfUrl;

  PanVerificationSubmitModel({
    this.status,
    this.message,
    this.data,
    this.uid,
    this.pdfUrl,
  });

  factory PanVerificationSubmitModel.fromJson(Map<String, dynamic> json) =>
      PanVerificationSubmitModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : SubmitData.fromJson(json["data"]),
        uid: json["uid"],
        pdfUrl: json["pdf_url"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
        "uid": uid,
        "pdf_url": pdfUrl,
      };
}

class SubmitData {
  String? nameValidated;
  String? name;
  int? nameMatchScore;
  String? pan;
  String? seedingStatus;
  bool? nameMatch;
  String? panDisplayName;
  String? status;

  SubmitData({
    this.nameValidated,
    this.name,
    this.nameMatchScore,
    this.pan,
    this.seedingStatus,
    this.nameMatch,
    this.panDisplayName,
    this.status,
  });

  factory SubmitData.fromJson(Map<String, dynamic> json) => SubmitData(
        nameValidated: json["name_validated"],
        name: json["name"],
        nameMatchScore: json["name_match_score"],
        pan: json["pan"],
        seedingStatus: json["seeding_status"],
        nameMatch: json["name_match"],
        panDisplayName: json["pan_display_name"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "name_validated": nameValidated,
        "name": name,
        "name_match_score": nameMatchScore,
        "pan": pan,
        "seeding_status": seedingStatus,
        "name_match": nameMatch,
        "pan_display_name": panDisplayName,
        "status": status,
      };
}

ShowPanDataModel showPanDataModelFromJson(String str) =>
    ShowPanDataModel.fromJson(json.decode(str));

String showPanDataModelToJson(ShowPanDataModel data) =>
    json.encode(data.toJson());

class ShowPanDataModel {
  int? status;
  String? message;
  ShowData? data;

  ShowPanDataModel({
    this.status,
    this.message,
    this.data,
  });

  factory ShowPanDataModel.fromJson(Map<String, dynamic> json) =>
      ShowPanDataModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : ShowData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class ShowData {
  int? id;
  String? uid;
  int? requestId;
  int? serviceRequestId;
  String? documentType;
  String? documentNumber;
  String? dob;
  String? panNumber;
  String? status;
  String? dataPreference;
  String? reason;
  List<dynamic>? documents;
  String? documentPdfFile;
  String? documentScanFile;

  ShowData({
    this.id,
    this.uid,
    this.requestId,
    this.serviceRequestId,
    this.documentType,
    this.documentNumber,
    this.dob,
    this.panNumber,
    this.status,
    this.dataPreference,
    this.reason,
    this.documents,
    this.documentPdfFile,
    this.documentScanFile,
  });

  factory ShowData.fromJson(Map<String, dynamic> json) => ShowData(
        id: json["id"],
        uid: json["uid"],
        requestId: json["request_id"],
        serviceRequestId: json["service_request_id"],
        documentType: json["document_type"],
        documentNumber: json["document_number"],
        dob: json["dob"],
        panNumber: json["pan_number"],
        status: json["status"],
        dataPreference: json["data_preference"],
        reason: json["reason"],
        documents: json["documents"] == null
            ? null
            : List<dynamic>.from(json["documents"]),
        documentPdfFile: json["document_pdf_file"],
        documentScanFile: json["document_scan_file"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "uid": uid,
        "request_id": requestId,
        "service_request_id": serviceRequestId,
        "document_type": documentType,
        "document_number": documentNumber,
        "dob": dob,
        "pan_number": panNumber,
        "status": status,
        "data_preference": dataPreference,
        "reason": reason,
        "documents": documents == null ? null : List<dynamic>.from(documents!),
        "document_pdf_file": documentPdfFile,
        "document_scan_file": documentScanFile,
      };
}
