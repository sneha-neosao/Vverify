// To parse this JSON data, do
//
//     final transactionCheckout = transactionCheckoutFromJson(jsonString);

import 'dart:convert';

TransactionCheckout transactionCheckoutFromJson(String str) => TransactionCheckout.fromJson(json.decode(str));

String transactionCheckoutToJson(TransactionCheckout data) => json.encode(data.toJson());

class TransactionCheckout {
  int? customerId;
  int? entityId;
  String? paymentGateway;
  String? paymentMode;
  int? quantity;
  List<Item>? items;

  TransactionCheckout({
    this.customerId,
    this.entityId,
    this.paymentGateway,
    this.paymentMode,
    this.quantity,
    this.items,
  });

  factory TransactionCheckout.fromJson(Map<String, dynamic> json) => TransactionCheckout(
    customerId: json["customer_id"],
    entityId: json["entity_id"],
    paymentGateway: json["payment_gateway"],
    paymentMode: json["payment_mode"],
    quantity: json["quantity"],
    items: json["items"] == null ? [] : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "customer_id": customerId,
    "entity_id": entityId,
    "payment_gateway": paymentGateway,
    "payment_mode": paymentMode,
    "quantity": quantity,
    "items": items == null ? [] : List<dynamic>.from(items!.map((x) => x.toJson())),
  };
}

class Item {
  int? serviceId;
  int? price;

  Item({
    this.serviceId,
    this.price,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    serviceId: json["service_id"],
    price: json["price"],
  );

  Map<String, dynamic> toJson() => {
    "service_id": serviceId,
    "price": price,
  };
}
