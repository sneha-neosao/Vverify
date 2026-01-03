// To parse this JSON data, do
//
//     final collageNameModel = collageNameModelFromJson(jsonString);

import 'dart:convert';
CollageNameModel collageNameModelFromJson(String str) => CollageNameModel.fromJson(json.decode(str));

String collageNameModelToJson(CollageNameModel data) => json.encode(data.toJson());

class CollageNameModel {
  int? status;
  String? message;
  List<Datum>? data;

  CollageNameModel({
    this.status,
    this.message,
    this.data,
  });

  factory CollageNameModel.fromJson(Map<String, dynamic> json) => CollageNameModel(
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
  String? schoolCollegeName;

  Datum({
    this.id,
    this.schoolCollegeName,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    schoolCollegeName: json["school_college_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "school_college_name": schoolCollegeName,
  };
}
