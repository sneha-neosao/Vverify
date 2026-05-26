class AllEntitiesModel {
  int? status;
  String? message;
  List<AllEntityData>? data;

  AllEntitiesModel({this.status, this.message, this.data});

  factory AllEntitiesModel.fromJson(Map<String, dynamic> json) {
    return AllEntitiesModel(
      status: json['status'],
      message: json['message'],
      data: json['data'] == null
          ? []
          : List<AllEntityData>.from(
              json['data'].map((x) => AllEntityData.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.map((x) => x.toJson()).toList(),
    };
  }
}

class AllEntityData {
  int? id;
  int? groupId;
  String? entityName;
  int? isActive;
  int? isDelete;
  String? createdAt;
  String? updatedAt;
  String? entityIcon;
  String? entityDescription;
  int? orderId;
  String? actualPrice;
  String? discountPrice;

  AllEntityData({
    this.id,
    this.groupId,
    this.entityName,
    this.isActive,
    this.isDelete,
    this.createdAt,
    this.updatedAt,
    this.entityIcon,
    this.entityDescription,
    this.orderId,
    this.actualPrice,
    this.discountPrice,
  });

  factory AllEntityData.fromJson(Map<String, dynamic> json) {
    return AllEntityData(
      id: json['id'],
      groupId: json['group_id'],
      entityName: json['entity_name'],
      isActive: json['is_active'],
      isDelete: json['is_delete'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      entityIcon: json['entity_icon'],
      entityDescription: json['entity_description'],
      orderId: json['order_id'] is String
          ? int.tryParse(json['order_id'])
          : json['order_id'],
      actualPrice: json['actual_price'],
      discountPrice: json['discount_price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'group_id': groupId,
      'entity_name': entityName,
      'is_active': isActive,
      'is_delete': isDelete,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'entity_icon': entityIcon,
      'entity_description': entityDescription,
      'order_id': orderId,
      'actual_price': actualPrice,
      'discount_price': discountPrice,
    };
  }
}
