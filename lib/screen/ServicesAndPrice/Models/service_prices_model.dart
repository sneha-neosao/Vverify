// To parse this JSON data, do
//
//     final servicePriceModel = servicePriceModelFromJson(jsonString);

import 'dart:convert';

ServicePriceModel servicePriceModelFromJson(String str) =>
    ServicePriceModel.fromJson(json.decode(str));

String servicePriceModelToJson(ServicePriceModel data) =>
    json.encode(data.toJson());

class ServicePriceModel {
  int? status;
  String? message;
  List<Datum>? data;
  List<Datum>? suggestionCombos;
  String? actualPrice;
  String? discountPrice;

  ServicePriceModel({
    this.status,
    this.message,
    this.data,
    this.suggestionCombos,
    this.actualPrice,
    this.discountPrice,
  });

  factory ServicePriceModel.fromJson(Map<String, dynamic> json) =>
      ServicePriceModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        suggestionCombos: json["suggestion_combos"] == null
            ? []
            : List<Datum>.from(json["suggestion_combos"]!.map((x) => Datum.fromJson(x))),
        actualPrice: json["actual_price"]?.toString(),
        discountPrice: json["discount_price"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "suggestion_combos": suggestionCombos == null
            ? []
            : List<dynamic>.from(suggestionCombos!.map((x) => x.toJson())),
        "actual_price": actualPrice,
        "discount_price": discountPrice,
      };
}

class Datum {
  int? id;
  String? serviceTitle;
  String? serviceDescription;
  String? serviceIcon;
  String? servicePrice;
  int? isDeveloped;

  Datum({
    this.id,
    this.serviceTitle,
    this.serviceDescription,
    this.serviceIcon,
    this.servicePrice,
    this.isDeveloped,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        serviceTitle: json["service_title"],
        serviceDescription: json["service_description"],
        serviceIcon: json["service_icon"],
        servicePrice: json["service_price"],
        isDeveloped: json["is_developed"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "service_title": serviceTitle,
        "service_description": serviceDescription,
        "service_icon": serviceIcon,
        "service_price": servicePrice,
        "is_developed": isDeveloped,
      };
}
