import 'dart:convert';

CheckoutModel checkoutModelFromJson(String str) =>
    CheckoutModel.fromJson(json.decode(str));

String checkoutModelToJson(CheckoutModel data) =>
    json.encode(data.toJson());

class CheckoutModel {
  final int? status;
  final String? message;
  final Transaction? transaction;
  final int? finalTotal;

  CheckoutModel({
    this.status,
    this.message,
    this.transaction,
    this.finalTotal,
  });

  factory CheckoutModel.fromJson(Map<String, dynamic> json) => CheckoutModel(
    status: int.tryParse(json["status"].toString()),
    message: json["message"],
    transaction: json["transaction"] == null
        ? null
        : Transaction.fromJson(json["transaction"]),
    finalTotal: int.tryParse(json["final_total"].toString()),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "transaction": transaction?.toJson(),
    "final_total": finalTotal,
  };
}

class Transaction {
  final String? txnId;
  final DateTime? txnDate;
  final int? customerId;
  final int? entityId;
  final int? quantity;
  final String? txnStatus;
  final String? paymentGateway;
  final String? paymentMode;
  final int? subTotal;
  final String? taxPercent;
  final int? taxTotal;
  final int? finalTotal;
  final dynamic couponId;
  final int? couponDiscount;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final int? id;
  final String? paymentOrderId;
  final PaymentData? paymentData;

  Transaction({
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
    this.couponId,
    this.couponDiscount,
    this.updatedAt,
    this.createdAt,
    this.id,
    this.paymentOrderId,
    this.paymentData,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    txnId: json["txn_id"],
    txnDate: json["txn_date"] == null
        ? null
        : DateTime.parse(json["txn_date"]),
    customerId: int.tryParse(json["customer_id"].toString()),
    entityId: int.tryParse(json["entity_id"].toString()),
    quantity: int.tryParse(json["quantity"].toString()),
    txnStatus: json["txn_status"],
    paymentGateway: json["payment_gateway"],
    paymentMode: json["payment_mode"],
    subTotal: int.tryParse(json["sub_total"].toString()),
    taxPercent: json["tax_percent"]?.toString(),
    taxTotal: int.tryParse(json["tax_total"].toString()),
    finalTotal: int.tryParse(json["final_total"].toString()),
    couponId: json["coupon_id"],
    couponDiscount: int.tryParse(json["coupon_discount"].toString()),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    id: int.tryParse(json["id"].toString()),
    paymentOrderId: json["payment_order_id"],
    paymentData: json["payment_data"] == null
        ? null
        : PaymentData.fromJson(json["payment_data"]),
  );

  Map<String, dynamic> toJson() => {
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
    "coupon_id": couponId,
    "coupon_discount": couponDiscount,
    "updated_at": updatedAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "id": id,
    "payment_order_id": paymentOrderId,
    "payment_data": paymentData?.toJson(),
  };
}

class PaymentData {
  final bool? success;
  final String? orderId;
  final String? token;
  final int? expireAt;

  PaymentData({
    this.success,
    this.orderId,
    this.token,
    this.expireAt,
  });

  factory PaymentData.fromJson(Map<String, dynamic> json) => PaymentData(
    success: json["success"],
    orderId: json["orderId"],
    token: json["token"],
    expireAt: int.tryParse(json["expireAt"].toString()),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "orderId": orderId,
    "token": token,
    "expireAt": expireAt,
  };
}
