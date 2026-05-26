import 'dart:convert';

DashboardEntitiesModel dashboardEntitiesModelFromJson(String str) =>
    DashboardEntitiesModel.fromJson(json.decode(str));

String dashboardEntitiesModelToJson(DashboardEntitiesModel data) =>
    json.encode(data.toJson());

class DashboardEntitiesModel {
  int? status;
  String? message;
  List<DashboardEntityItem>? data;

  DashboardEntitiesModel({
    this.status,
    this.message,
    this.data,
  });

  factory DashboardEntitiesModel.fromJson(Map<String, dynamic> json) =>
      DashboardEntitiesModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : List<DashboardEntityItem>.from(
                json["data"].map((x) => DashboardEntityItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class DashboardEntityItem {
  int? id;
  String? entityName;
  String? entityDescription;
  String? entityIcon;

  DashboardEntityItem({
    this.id,
    this.entityName,
    this.entityDescription,
    this.entityIcon,
  });

  factory DashboardEntityItem.fromJson(Map<String, dynamic> json) =>
      DashboardEntityItem(
        id: json["id"],
        entityName: json["entity_name"],
        entityDescription: json["entity_description"],
        entityIcon: json["entity_icon"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "entity_name": entityName,
        "entity_description": entityDescription,
        "entity_icon": entityIcon,
      };
}
