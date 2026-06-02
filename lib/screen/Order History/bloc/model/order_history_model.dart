// To parse this JSON data, do
//
//     final orderHistoryModel = orderHistoryModelFromJson(jsonString);

import 'dart:convert';

OrderHistoryModel orderHistoryModelFromJson(String str) =>
    OrderHistoryModel.fromJson(json.decode(str));

String orderHistoryModelToJson(OrderHistoryModel data) =>
    json.encode(data.toJson());

class OrderHistoryModel {
  int? status;
  String? message;
  int? pages;
  int? records;
  List<Datum>? data;
  List<int>? transactionIds;

  OrderHistoryModel({
    this.status,
    this.message,
    this.pages,
    this.records,
    this.data,
    this.transactionIds,
  });

  factory OrderHistoryModel.fromJson(Map<String, dynamic> json) =>
      OrderHistoryModel(
        status: json["status"],
        message: json["message"],
        pages: json["pages"],
        records: json["records"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        transactionIds: json["transaction_ids"] == null
            ? []
            : List<int>.from(json["transaction_ids"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "pages": pages,
        "records": records,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "transaction_ids": transactionIds == null
            ? []
            : List<dynamic>.from(transactionIds!.map((x) => x)),
      };
}

class Datum {
  int? id;
  String? txnId;
  DateTime? txnDate;
  int? customerId;
  int? entityId;
  int? quantity;
  String? txnStatus;
  String? paymentGateway;
  String? paymentMode;
  String? subTotal;
  String? taxPercent;
  String? taxTotal;
  String? finalTotal;
  dynamic paymentData;
  dynamic paymentResponse;
  dynamic webhookResponse;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<Service>? services;

  Datum({
    this.id,
    this.txnId,
    this.txnDate,
    this.customerId,
    this.entityId,
    this.quantity,
    this.txnStatus,
    this.paymentGateway,
    this.paymentMode,
    this.subTotal,
    this.taxPercent,
    this.taxTotal,
    this.finalTotal,
    this.paymentData,
    this.paymentResponse,
    this.webhookResponse,
    this.createdAt,
    this.updatedAt,
    this.services,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        txnId: json["txn_id"],
        txnDate:
            json["txn_date"] == null ? null : DateTime.parse(json["txn_date"]),
        customerId: json["customer_id"],
        entityId: json["entity_id"],
        quantity: json["quantity"],
        txnStatus: json["txn_status"]!,
        paymentGateway: json["payment_gateway"]!,
        paymentMode: json["payment_mode"]!,
        subTotal: json["sub_total"],
        taxPercent: json["tax_percent"],
        taxTotal: json["tax_total"],
        finalTotal: json["final_total"],
        paymentData: json["payment_data"],
        paymentResponse: json["payment_response"],
        webhookResponse: json["webhook_response"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        services: json["services"] == null
            ? []
            : List<Service>.from(
                json["services"]!.map((x) => Service.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "txn_id": txnId,
        "txn_date": txnDate?.toIso8601String(),
        "customer_id": customerId,
        "entity_id": entityId,
        "quantity": quantity,
        "txn_status": txnStatus,
        "payment_gateway": paymentGateway,
        "payment_mode": paymentMode,
        "sub_total": subTotal,
        "tax_percent": taxPercent,
        "tax_total": taxTotal,
        "final_total": finalTotal,
        "payment_data": paymentData,
        "payment_response": paymentResponse,
        "webhook_response": webhookResponse,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "services": services == null
            ? []
            : List<dynamic>.from(services!.map((x) => x.toJson())),
      };
}

class Service {
  int? id;
  String? serviceTitle;

  Service({
    this.id,
    this.serviceTitle,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        id: json["id"],
        serviceTitle: json["service_title"]!,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "service_title": serviceTitle,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

class DataModel {
  final int id;
  final String name;

  DataModel({required this.id, required this.name});

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      id: json['id'],
      name: json['title'],
    );
  }
}
