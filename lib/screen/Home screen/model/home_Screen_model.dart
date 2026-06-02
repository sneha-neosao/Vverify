import 'dart:convert';

HomeScreenModel homeScreenModelFromJson(String str) =>
    HomeScreenModel.fromJson(json.decode(str));

String homeScreenModelToJson(HomeScreenModel data) =>
    json.encode(data.toJson());

class HomeScreenModel {
  int? status;
  String? message;
  List<HomeScreenData>? data;

  HomeScreenModel({
    this.status,
    this.message,
    this.data,
  });

  factory HomeScreenModel.fromJson(Map<String, dynamic> json) =>
      HomeScreenModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<HomeScreenData>.from(
                json["data"]!.map((x) => HomeScreenData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class HomeScreenData {
  int? id;
  String? title;
  List<Entity>? entities;

  HomeScreenData({
    this.id,
    this.title,
    this.entities,
  });

  factory HomeScreenData.fromJson(Map<String, dynamic> json) => HomeScreenData(
        id: json["id"],
        title: json["title"],
        entities: json["entities"] == null
            ? []
            : List<Entity>.from(
                json["entities"]!.map((x) => Entity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "entities": entities == null
            ? []
            : List<dynamic>.from(entities!.map((x) => x.toJson())),
      };
}

class Entity {
  int? id;
  int? groupId;
  String? entityName;
  String? entityIcon;
  String? entityDescription;

  Entity({
    this.id,
    this.groupId,
    this.entityName,
    this.entityIcon,
    this.entityDescription,
  });

  factory Entity.fromJson(Map<String, dynamic> json) => Entity(
        id: json["id"],
        groupId: json["group_id"],
        entityName: json["entity_name"],
        entityIcon: json["entity_icon"],
        entityDescription: json["entity_description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "group_id": groupId,
        "entity_name": entityName,
        "entity_icon": entityIcon,
        "entity_description": entityDescription,
      };
}
