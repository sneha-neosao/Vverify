import 'dart:convert';

Post postFromJson(String str) => Post.fromJson(json.decode(str));
String postToJson(Post data) => json.encode(data.toJson());

class Post {
  int? status;
  String? message;
  int? pages;
  int? records;
  List<History>? data;
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
    data: json["data"] == null
        ? []
        : List<History>.from(
        json["data"].map((x) => History.fromJson(x))),
    transactionIds: json["transaction_ids"] == null
        ? []
        : List<int>.from(json["transaction_ids"].map((x) => x)),
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

class History {
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
  PaymentData? paymentData;
  dynamic paymentResponse;
  dynamic webhookResponse;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? couponId;
  String? couponDiscount;
  String? paymentOrderId;
  List<Service>? services;
  String? entityName;
  Entity? entity;

  History({
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
    this.couponId,
    this.couponDiscount,
    this.paymentOrderId,
    this.services,
    this.entityName,
    this.entity,
  });

  factory History.fromJson(Map<String, dynamic> json) => History(
    id: json["id"],
    txnId: json["txn_id"],
    txnDate:
    json["txn_date"] == null ? null : DateTime.parse(json["txn_date"]),
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
    paymentData: json["payment_data"] == null
        ? null
        : PaymentData.fromJson(json["payment_data"]),
    paymentResponse: json["payment_response"],
    webhookResponse: json["webhook_response"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    couponId: json["coupon_id"],
    couponDiscount: json["coupon_discount"],
    paymentOrderId: json["payment_order_id"],
    services: json["services"] == null
        ? []
        : List<Service>.from(
        json["services"].map((x) => Service.fromJson(x))),
    entityName: json["entity_name"],
    entity:
    json["entity"] == null ? null : Entity.fromJson(json["entity"]),
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
    "payment_data": paymentData?.toJson(),
    "payment_response": paymentResponse,
    "webhook_response": webhookResponse,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "coupon_id": couponId,
    "coupon_discount": couponDiscount,
    "payment_order_id": paymentOrderId,
    "services": services == null
        ? []
        : List<dynamic>.from(services!.map((x) => x.toJson())),
    "entity_name": entityName,
    "entity": entity?.toJson(),
  };
}

class PaymentData {
  bool? success;
  String? redirectUrl;
  String? orderId;
  String? state;
  int? expireAt;

  PaymentData({
    this.success,
    this.redirectUrl,
    this.orderId,
    this.state,
    this.expireAt,
  });

  factory PaymentData.fromJson(Map<String, dynamic> json) => PaymentData(
    success: json["success"],
    redirectUrl: json["redirect_url"],
    orderId: json["orderId"],
    state: json["state"],
    expireAt: json["expireAt"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "redirect_url": redirectUrl,
    "orderId": orderId,
    "state": state,
    "expireAt": expireAt,
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
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
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
