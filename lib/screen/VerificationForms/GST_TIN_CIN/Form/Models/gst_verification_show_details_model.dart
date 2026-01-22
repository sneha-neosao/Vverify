// To parse this JSON data, do
//
//     final gstPanCinShowDataModel = gstPanCinShowDataModelFromJson(jsonString);

import 'dart:convert';

GstPanCinShowDataModel gstPanCinShowDataModelFromJson(String str) => GstPanCinShowDataModel.fromJson(json.decode(str));

String gstPanCinShowDataModelToJson(GstPanCinShowDataModel data) => json.encode(data.toJson());

class GstPanCinShowDataModel {
  int? status;
  String? message;
  Data? data;

  GstPanCinShowDataModel({
    this.status,
    this.message,
    this.data,
  });

  factory GstPanCinShowDataModel.fromJson(Map<String, dynamic> json) => GstPanCinShowDataModel(
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
  dynamic gstNumber;
  dynamic cinNumber;
  dynamic panNumber;
  String? status;
  String? reason;
  String? gstDocument;
  String? panDocument;
  String? cinDocument;

  Data({
    this.id,
    this.uid,
    this.requestId,
    this.serviceRequestId,
    this.gstNumber,
    this.cinNumber,
    this.panNumber,
    this.status,
    this.reason,
    this.gstDocument,
    this.panDocument,
    this.cinDocument,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    uid: json["uid"],
    requestId: json["request_id"],
    serviceRequestId: json["service_request_id"],
    gstNumber: json["gst_number"],
    cinNumber: json["cin_number"],
    panNumber: json["pan_number"],
    status: json["status"],
    reason: json["reason"],
    gstDocument: json["gst_document"],
    panDocument: json["pan_document"],
    cinDocument: json["cin_document"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "uid": uid,
    "request_id": requestId,
    "service_request_id": serviceRequestId,
    "gst_number": gstNumber,
    "cin_number": cinNumber,
    "pan_number": panNumber,
    "status": status,
    "reason": reason,
    "gst_document": gstDocument,
    "pan_document": panDocument,
    "cin_document": cinDocument,
  };
}
