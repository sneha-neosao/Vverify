// To parse this JSON data, do
//
//     final policeStationIdModel = policeStationIdModelFromJson(jsonString);

import 'dart:convert';

PoliceStationIdModel policeStationIdModelFromJson(String str) => PoliceStationIdModel.fromJson(json.decode(str));

String policeStationIdModelToJson(PoliceStationIdModel data) => json.encode(data.toJson());

class PoliceStationIdModel {
  int? status;
  String? message;
  List<Datum>? data;

  PoliceStationIdModel({
    this.status,
    this.message,
    this.data,
  });

  factory PoliceStationIdModel.fromJson(Map<String, dynamic> json) => PoliceStationIdModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  int? id;
  String? stationName;

  Datum({
    this.id,
    this.stationName,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    stationName: json["station_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "station_name": stationName,
  };
}
