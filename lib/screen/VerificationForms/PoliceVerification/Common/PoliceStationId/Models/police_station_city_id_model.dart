import 'dart:convert';

PoliceStationCityIdModel policeStationCityIdModelFromJson(String str) => PoliceStationCityIdModel.fromJson(json.decode(str));

String policeStationCityIdModelToJson(PoliceStationCityIdModel data) => json.encode(data.toJson());

class PoliceStationCityIdModel {
  int? status;
  String? message;
  List<Datum>? data;

  PoliceStationCityIdModel({
    this.status,
    this.message,
    this.data,
  });

  factory PoliceStationCityIdModel.fromJson(Map<String, dynamic> json) => PoliceStationCityIdModel(
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
  String? cityName;

  Datum({
    this.id,
    this.cityName,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    cityName: json["city_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "city_name": cityName,
  };
}
