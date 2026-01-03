// To parse this JSON data, do
//
//     final checkoutModel = checkoutModelFromJson(jsonString);

import 'dart:convert';
CheckoutModel checkoutModelFromJson(String str) => CheckoutModel.fromJson(json.decode(str));

String checkoutModelToJson(CheckoutModel data) => json.encode(data.toJson());

class CheckoutModel {
  int? status;
  String? message;
  String? transactionId;
  Transaction? transaction;

  CheckoutModel({
    this.status,
    this.message,
    this.transactionId,
    this.transaction,
  });

  factory CheckoutModel.fromJson(Map<String, dynamic> json) => CheckoutModel(
    status: json["status"],
    message: json["message"],
    transactionId: json["transaction_id"],
    transaction: json["transaction"] == null ? null : Transaction.fromJson(json["transaction"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "transaction_id": transactionId,
    "transaction": transaction?.toJson(),
  };
}

class Transaction {
  String? txnId;
  String? txnDate;
  int? customerId;
  int? entityId;
  int? quantity;
  String? txnStatus;
  String? paymentGateway;
  String? paymentMode;
  int? subTotal;
  String? taxPercent;
  int? taxTotal;
  int? finalTotal;
  String? updatedAt;
  String? createdAt;
  int? id;

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
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    txnId: json["txn_id"],
    txnDate: json["txn_date"],
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
    updatedAt: json["updated_at"],
    createdAt: json["created_at"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "txn_id": txnId,
    "txn_date": txnDate,
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
    "updated_at": updatedAt,
    "created_at": createdAt,
    "id": id,
  };
  
}
