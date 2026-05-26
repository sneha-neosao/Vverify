import 'dart:convert';

EntityDataModel entityDataModelFromJson(String str) =>
    EntityDataModel.fromJson(json.decode(str));

String entityDataModelToJson(EntityDataModel data) =>
    json.encode(data.toJson());

class EntityDataModel {
  int? status;
  String? message;
  EntityCountsData? data;

  EntityDataModel({
    this.status,
    this.message,
    this.data,
  });

  factory EntityDataModel.fromJson(Map<String, dynamic> json) =>
      EntityDataModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : EntityCountsData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class EntityCountsData {
  List<ServiceCountItem>? serviceCounts;

  EntityCountsData({
    this.serviceCounts,
  });

  factory EntityCountsData.fromJson(Map<String, dynamic> json) =>
      EntityCountsData(
        serviceCounts: json["serviceCounts"] == null
            ? null
            : List<ServiceCountItem>.from(
                json["serviceCounts"].map((x) => ServiceCountItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "serviceCounts": serviceCounts == null
            ? null
            : List<dynamic>.from(serviceCounts!.map((x) => x.toJson())),
      };
}

class ServiceCountItem {
  int? serviceId;
  String? serviceTitle;
  int? completeCount;
  int? pendingCount;

  ServiceCountItem({
    this.serviceId,
    this.serviceTitle,
    this.completeCount,
    this.pendingCount,
  });

  factory ServiceCountItem.fromJson(Map<String, dynamic> json) =>
      ServiceCountItem(
        serviceId: json["service_id"],
        serviceTitle: json["service_title"],
        completeCount: json["complete_count"],
        pendingCount: json["pending_count"],
      );

  Map<String, dynamic> toJson() => {
        "service_id": serviceId,
        "service_title": serviceTitle,
        "complete_count": completeCount,
        "pending_count": pendingCount,
      };
}
