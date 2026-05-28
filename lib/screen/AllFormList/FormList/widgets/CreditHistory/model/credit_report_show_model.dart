import 'dart:convert';

CreditReportShowModel creditReportShowModelFromJson(String str) =>
    CreditReportShowModel.fromJson(json.decode(str));

String creditReportShowModelToJson(CreditReportShowModel data) =>
    json.encode(data.toJson());

class CreditReportShowModel {
  int? status;
  String? message;
  String? uid;
  String? pdfUrl;
  String? reportUrl;
  CreditData? data;

  CreditReportShowModel({
    this.status,
    this.message,
    this.uid,
    this.pdfUrl,
    this.reportUrl,
    this.data,
  });

  factory CreditReportShowModel.fromJson(Map<String, dynamic> json) {
    final dataMap = json["data"];
    CreditData? creditData;
    String? innerPdfUrl;
    String? innerReportUrl;
    if (dataMap is Map<String, dynamic>) {
      creditData = CreditData.fromJson(dataMap);
      innerPdfUrl = dataMap["pdf_url"] ?? dataMap["report_url"];
      innerReportUrl = dataMap["report_url"] ?? dataMap["pdf_url"];
    }

    return CreditReportShowModel(
      status: json["status"] is int
          ? json["status"]
          : int.tryParse(json["status"]?.toString() ?? ""),
      message: json["message"]?.toString(),
      uid: json["uid"]?.toString() ??
          (dataMap is Map ? dataMap["uid"]?.toString() : null),
      pdfUrl: json["pdf_url"]?.toString() ?? innerPdfUrl,
      reportUrl: json["report_url"]?.toString() ?? innerReportUrl,
      data: creditData,
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "uid": uid,
        "pdf_url": pdfUrl,
        "report_url": reportUrl,
        "data": data?.toJson(),
      };
}

class CreditData {
  String? reportUrl;
  String? pdfUrl;
  String? uid;
  String? status;
  String? documentPdfFile;
  String? documentType;
  String? documentNumber;
  String? reason;
  CreditResult? result;

  CreditData({
    this.reportUrl,
    this.pdfUrl,
    this.uid,
    this.status,
    this.documentPdfFile,
    this.documentType,
    this.documentNumber,
    this.reason,
    this.result,
  });

  factory CreditData.fromJson(Map<String, dynamic> json) {
    return CreditData(
      reportUrl: json["report_url"]?.toString(),
      pdfUrl: json["pdf_url"]?.toString(),
      uid: json["uid"]?.toString(),
      status: json["status"]?.toString(),
      documentPdfFile: json["document_pdf_file"]?.toString(),
      documentType: json["document_type"]?.toString(),
      documentNumber: json["document_number"]?.toString(),
      reason: json["reason"]?.toString(),
      result: json["result"] == null
          ? (json["data"] is Map ? CreditResult.fromJson(json["data"]) : null)
          : CreditResult.fromJson(json["result"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "report_url": reportUrl,
        "pdf_url": pdfUrl,
        "uid": uid,
        "status": status,
        "document_pdf_file": documentPdfFile,
        "document_type": documentType,
        "document_number": documentNumber,
        "reason": reason,
        "result": result?.toJson(),
      };
}

class CreditResult {
  String? msg;
  double? charges;
  String? status;
  Map<String, dynamic>? resultJson;

  CreditResult({
    this.msg,
    this.charges,
    this.status,
    this.resultJson,
  });

  factory CreditResult.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic>? rJson;
    if (json["data"] is Map &&
        (json["data"] as Map).containsKey("result_json")) {
      rJson = Map<String, dynamic>.from(json["data"]["result_json"]);
    } else if (json["result_json"] is Map) {
      rJson = Map<String, dynamic>.from(json["result_json"]);
    }

    return CreditResult(
      msg: json["msg"]?.toString(),
      charges: json["charges"] is num
          ? (json["charges"] as num).toDouble()
          : double.tryParse(json["charges"]?.toString() ?? ""),
      status: json["status"]?.toString(),
      resultJson: rJson,
    );
  }

  Map<String, dynamic> toJson() => {
        "msg": msg,
        "charges": charges,
        "status": status,
        "result_json": resultJson,
      };
}
