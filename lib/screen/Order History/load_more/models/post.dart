// To parse this JSON data, do
//
//     final post = postFromJson(jsonString);

import 'dart:convert';

Post postFromJson(String str) => Post.fromJson(json.decode(str));

String postToJson(Post data) => json.encode(data.toJson());

class Post {
  int? status;
  String? message;
  int? pages;
  int? records;
  List<history>? data;
  List<int>? transactionIds;

  Post({
    this.status,
    this.message,
    this.pages,
    this.records,
    this.data,
    this.transactionIds,
  });

  factory Post.fromJson(Map<String, dynamic> json) => Post(
    status: json["status"],
    message: json["message"],
    pages: json["pages"],
    records: json["records"],
    data: json["data"] == null ? [] : List<history>.from(json["data"]!.map((x) => history.fromJson(x))),
    transactionIds: json["transaction_ids"] == null ? [] : List<int>.from(json["transaction_ids"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "pages": pages,
    "records": records,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "transaction_ids": transactionIds == null ? [] : List<dynamic>.from(transactionIds!.map((x) => x)),
  };
}

class history {
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

  history({
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

  factory history.fromJson(Map<String, dynamic> json) => history(
    id: json["id"],
    txnId: json["txn_id"],
    txnDate: json["txn_date"] == null ? null : DateTime.parse(json["txn_date"]),
    customerId: json["customer_id"],
    entityId: json["entity_id"],
    quantity: json["quantity"],
    txnStatus: json["txn_status"],
    paymentGateway: json["payment_gateway"],
    paymentMode: json["payment_mode"],
    subTotal: json["sub_total"],
    taxPercent: json["tax_percent"],
    taxTotal: json["tax_total"],
    finalTotal: json["final_total"],
    paymentData: json["payment_data"],
    paymentResponse: json["payment_response"],
    webhookResponse: json["webhook_response"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    services: json["services"] == null ? [] : List<Service>.from(json["services"]!.map((x) => Service.fromJson(x))),
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
    "services": services == null ? [] : List<dynamic>.from(services!.map((x) => x.toJson())),
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
    serviceTitle: json["service_title"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "service_title": serviceTitle,
  };
}
