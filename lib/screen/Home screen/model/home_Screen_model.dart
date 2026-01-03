// To parse this JSON data, do
//
//     final homeScreenModel = homeScreenModelFromJson(jsonString);

import 'dart:convert';

HomeScreenModel homeScreenModelFromJson(String str) => HomeScreenModel.fromJson(json.decode(str));

String homeScreenModelToJson(HomeScreenModel data) => json.encode(data.toJson());

class HomeScreenModel {
  int? status;
  String? message;
  List<Entity>? data;

  HomeScreenModel({
    this.status,
    this.message,
    this.data,
  });

  factory HomeScreenModel.fromJson(Map<String, dynamic> json) => HomeScreenModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? [] : List<Entity>.from(json["data"]!.map((x) => Entity.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Entity {
  int? id;
  String? entityName;
  String? entityIcon;

  Entity({
    this.id,
    this.entityName,
    this.entityIcon,
  });

  factory Entity.fromJson(Map<String, dynamic> json) => Entity(
    id: json["id"],
    entityName: json["entity_name"],
    entityIcon: json["entity_icon"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "entity_name": entityName,
    "entity_icon": entityIcon,
  };
}
