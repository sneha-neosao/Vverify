
import 'dart:convert';
UniversityNameModel universityNameModelFromJson(String str) => UniversityNameModel.fromJson(json.decode(str));

String universityNameModelToJson(UniversityNameModel data) => json.encode(data.toJson());

class UniversityNameModel {
  int? status;
  String? message;
  List<Datum>? data;

  UniversityNameModel({
    this.status,
    this.message,
    this.data,
  });

  factory UniversityNameModel.fromJson(Map<String, dynamic> json) => UniversityNameModel(
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
  String? uniBoardName;

  Datum({
    this.id,
    this.uniBoardName,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    uniBoardName: json["uni_board_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "uni_board_name": uniBoardName,
  };
}
