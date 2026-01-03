// To parse this JSON data, do
//
//     final orderDetailsModel = orderDetailsModelFromJson(jsonString);

import 'dart:convert';

OrderDetailsModel orderDetailsModelFromJson(String str) => OrderDetailsModel.fromJson(json.decode(str));

String orderDetailsModelToJson(OrderDetailsModel data) => json.encode(data.toJson());

class OrderDetailsModel {
  int? status;
  String? message;
  Data? data;

  OrderDetailsModel({
    this.status,
    this.message,
    this.data,
  });

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) => OrderDetailsModel(
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
  Entity? entity;
  List<Item>? items;

  Data({
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
    this.entity,
    this.items,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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
    entity: json["entity"] == null ? null : Entity.fromJson(json["entity"]),
    items: json["items"] == null ? [] : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
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
    "entity": entity?.toJson(),
    "items": items == null ? [] : List<dynamic>.from(items!.map((x) => x.toJson())),
  };
}

class Entity {
  int? id;
  String? entityName;
  int? isActive;
  int? isDelete;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? entityIcon;

  Entity({
    this.id,
    this.entityName,
    this.isActive,
    this.isDelete,
    this.createdAt,
    this.updatedAt,
    this.entityIcon,
  });

  factory Entity.fromJson(Map<String, dynamic> json) => Entity(
    id: json["id"],
    entityName: json["entity_name"],
    isActive: json["is_active"],
    isDelete: json["is_delete"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    entityIcon: json["entity_icon"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "entity_name": entityName,
    "is_active": isActive,
    "is_delete": isDelete,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "entity_icon": entityIcon,
  };
}

class Item {
  int? id;
  int? transactionId;
  int? serviceId;
  int? quantity;
  String? price;
  String? amount;
  DateTime? createdAt;
  DateTime? updatedAt;
  Service? service;

  Item({
    this.id,
    this.transactionId,
    this.serviceId,
    this.quantity,
    this.price,
    this.amount,
    this.createdAt,
    this.updatedAt,
    this.service,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json["id"],
    transactionId: json["transaction_id"],
    serviceId: json["service_id"],
    quantity: json["quantity"],
    price: json["price"],
    amount: json["amount"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    service: json["service"] == null ? null : Service.fromJson(json["service"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "transaction_id": transactionId,
    "service_id": serviceId,
    "quantity": quantity,
    "price": price,
    "amount": amount,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "service": service?.toJson(),
  };
}

class Service {
  int? id;
  String? serviceTitle;
  String? serviceDescription;
  String? serviceIcon;
  int? isActive;
  int? isDelete;
  DateTime? createdAt;
  DateTime? updatedAt;

  Service({
    this.id,
    this.serviceTitle,
    this.serviceDescription,
    this.serviceIcon,
    this.isActive,
    this.isDelete,
    this.createdAt,
    this.updatedAt,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
    id: json["id"],
    serviceTitle: json["service_title"],
    serviceDescription: json["service_description"],
    serviceIcon: json["service_icon"],
    isActive: json["is_active"],
    isDelete: json["is_delete"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "service_title": serviceTitle,
    "service_description": serviceDescription,
    "service_icon": serviceIcon,
    "is_active": isActive,
    "is_delete": isDelete,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
