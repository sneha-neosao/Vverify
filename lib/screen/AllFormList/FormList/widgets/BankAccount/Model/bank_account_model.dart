import 'dart:convert';

ShowBankDataModel showBankDataModelFromJson(String str) =>
    ShowBankDataModel.fromJson(json.decode(str));

String showBankDataModelToJson(ShowBankDataModel data) =>
    json.encode(data.toJson());

class ShowBankDataModel {
  int? status;
  String? message;
  Data? data;

  ShowBankDataModel({
    this.status,
    this.message,
    this.data,
  });

  factory ShowBankDataModel.fromJson(Map<String, dynamic> json) =>
      ShowBankDataModel(
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
  int? requestId;
  int? serviceRequestId;
  String? accountNumber;
  String? ifscCode;
  String? beneficiaryName;
  String? nameAtBank;
  String? bankName;
  String? status;
  String? reason;
  String? documentPdfFile;

  Data({
    this.id,
    this.uid,
    this.requestId,
    this.serviceRequestId,
    this.accountNumber,
    this.ifscCode,
    this.beneficiaryName,
    this.nameAtBank,
    this.bankName,
    this.status,
    this.reason,
    this.documentPdfFile,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        uid: json["uid"],
        requestId: json["request_id"],
        serviceRequestId: json["service_request_id"],
        accountNumber: json["account_number"],
        ifscCode: json["ifsc_code"],
        beneficiaryName: json["beneficiary_name"],
        nameAtBank: json["name_at_bank"],
        bankName: json["bank_name"],
        status: json["status"],
        reason: json["reason"],
        documentPdfFile: json["document_pdf_file"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "uid": uid,
        "request_id": requestId,
        "service_request_id": serviceRequestId,
        "account_number": accountNumber,
        "ifsc_code": ifscCode,
        "beneficiary_name": beneficiaryName,
        "name_at_bank": nameAtBank,
        "bank_name": bankName,
        "status": status,
        "reason": reason,
        "document_pdf_file": documentPdfFile,
      };
}
