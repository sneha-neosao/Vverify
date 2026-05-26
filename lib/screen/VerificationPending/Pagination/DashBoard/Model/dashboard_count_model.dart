// To parse this JSON data, do
//
//     final dashboardCountModel = dashboardCountModelFromJson(jsonString);

import 'dart:convert';

DashboardCountModel dashboardCountModelFromJson(String str) =>
    DashboardCountModel.fromJson(json.decode(str));

String dashboardCountModelToJson(DashboardCountModel data) =>
    json.encode(data.toJson());

class DashboardCountModel {
  int? status;
  String? message;
  Data? data;

  DashboardCountModel({
    this.status,
    this.message,
    this.data,
  });

  factory DashboardCountModel.fromJson(Map<String, dynamic> json) =>
      DashboardCountModel(
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
  int? totalEntitiesPurchased;
  int? completed;
  int? pending;
  int? rejected;
  int? inProgress;

  Data({
    this.totalEntitiesPurchased,
    this.completed,
    this.pending,
    this.rejected,
    this.inProgress,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        totalEntitiesPurchased: json["total_entities_purchased"],
        completed: json["completed"],
        pending: json["pending"],
        rejected: json["rejected"],
        inProgress: json["in_progress"],
      );

  Map<String, dynamic> toJson() => {
        "total_entities_purchased": totalEntitiesPurchased,
        "completed": completed,
        "pending": pending,
        "rejected": rejected,
        "in_progress": inProgress,
      };
}
