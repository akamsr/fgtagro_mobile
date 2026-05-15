import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hive_ce/hive.dart';

part 'cartitems.g.dart';

@HiveType(typeId: 9)
class CartItem {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String? productId;
  @HiveField(2)
  final int? restaurantItemId;
  @HiveField(3)
  int qty;
  @HiveField(4)
  final int businessId;
  @HiveField(5)
  final String size;
  @HiveField(6)
  final String color;
  @HiveField(7)
  final String type;
  @HiveField(8)
  final int? discountId;
  @HiveField(9)
  final double? discountValue;
  @HiveField(10)
  final double originalPrice;
  @HiveField(11)
  final double finalPrice;
  @HiveField(12)
  final int? shippingRateId;
  @HiveField(13)
  final String? productName;
  @HiveField(14)
  final String? productPhoto;
  @HiveField(15)
  final String? sellerName;
  @HiveField(16)
  final String? sellerCity;
  @HiveField(17)
  final int availableStock;
  @HiveField(18)
  final String? unit;

  CartItem({
    required this.id,
    this.productId,
    this.restaurantItemId,
    required this.qty,
    required this.businessId,
    this.size = '',
    this.color = 'White',
    this.type = 'product',
    this.discountId,
    this.discountValue,
    this.originalPrice = 0,
    this.finalPrice = 0,
    this.shippingRateId,
    this.productName,
    this.productPhoto,
    this.sellerName,
    this.sellerCity,
    this.availableStock = 0,
    this.unit,
  });

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id']?.toInt() ?? 0,
      productId: map['productId']?.toString(),
      restaurantItemId: map['restaurantItemId']?.toInt(),
      qty: map['qty']?.toInt() ?? 1,
      businessId: map['businessId']?.toInt() ?? 0,
      size: map['size'] ?? '',
      color: map['color'] ?? 'White',
      type: map['type'] ?? 'product',
      discountId: map['discountId']?.toInt(),
      discountValue: map['discountValue']?.toDouble(),
      originalPrice: map['originalPrice']?.toDouble() ?? 0.0,
      finalPrice: map['finalPrice']?.toDouble() ?? 0.0,
      shippingRateId: map['shippingRateId']?.toInt(),
      productName: map['productName'],
      productPhoto: map['productPhoto'],
      sellerName: map['sellerName'],
      sellerCity: map['sellerCity'],
      availableStock: map['availableStock']?.toInt() ?? 0,
      unit: map['unit'],
    );
  }

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem.fromMap(json);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'restaurantItemId': restaurantItemId,
      'qty': qty,
      'businessId': businessId,
      'size': size,
      'color': color,
      'type': type,
      'discountId': discountId,
      'discountValue': discountValue,
      'originalPrice': originalPrice,
      'finalPrice': finalPrice,
      'shippingRateId': shippingRateId,
      'productName': productName,
      'productPhoto': productPhoto,
      'sellerName': sellerName,
      'sellerCity': sellerCity,
      'availableStock': availableStock,
      'unit': unit,
    };
  }

  CartItem copyWith({
    int? id,
    String? productId,
    int? restaurantItemId,
    int? qty,
    int? businessId,
    String? size,
    String? color,
    String? type,
    int? discountId,
    double? discountValue,
    double? originalPrice,
    double? finalPrice,
    int? shippingRateId,
    String? productName,
    String? productPhoto,
    String? sellerName,
    String? sellerCity,
    int? availableStock,
    String? unit,
  }) {
    return CartItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      restaurantItemId: restaurantItemId ?? this.restaurantItemId,
      qty: qty ?? this.qty,
      businessId: businessId ?? this.businessId,
      size: size ?? this.size,
      color: color ?? this.color,
      type: type ?? this.type,
      discountId: discountId ?? this.discountId,
      discountValue: discountValue ?? this.discountValue,
      originalPrice: originalPrice ?? this.originalPrice,
      finalPrice: finalPrice ?? this.finalPrice,
      shippingRateId: shippingRateId ?? this.shippingRateId,
      productName: productName ?? this.productName,
      productPhoto: productPhoto ?? this.productPhoto,
      sellerName: sellerName ?? this.sellerName,
      sellerCity: sellerCity ?? this.sellerCity,
      availableStock: availableStock ?? this.availableStock,
      unit: unit ?? this.unit,
    );
  }
}

@HiveType(typeId: 10)
class CartGroup {
  @HiveField(0)
  int businessId;
  @HiveField(1)
  List<CartItem> cartItems;
  @HiveField(2)
  bool selectedForCehckout;
  @HiveField(3)
  final int? businessBranchId;
  CartGroup({
    required this.businessId,
    required this.cartItems,
    required this.selectedForCehckout,
    this.businessBranchId,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'businessId': businessId});
    result.addAll({'businessBranchId': businessBranchId});
    result.addAll({'cartItems': cartItems.map((x) => x.toJson()).toList()});
    result.addAll({'selectedForCehckout': selectedForCehckout});

    return result;
  }

  factory CartGroup.fromMap(Map<String, dynamic> map) {
    return CartGroup(
      businessId: map['businessId']?.toInt() ?? 0,
      businessBranchId: map['businessBranchId'],
      cartItems: List<CartItem>.from(
        map['cartItems']?.map((x) => CartItem.fromMap(x)),
      ),
      selectedForCehckout: map['selectedForCehckout'] ?? false,
    );
  }

  factory CartGroup.fromJson(Map<String, dynamic> json) => CartGroup.fromMap(json);

  Map<String, dynamic> toJson() => toMap();

  String toJsonString() => json.encode(toMap());

  factory CartGroup.fromJsonString(String source) =>
      CartGroup.fromMap(json.decode(source));

  @override
  String toString() =>
      'CartGroup(businessId: $businessId, cartItems: $cartItems, selectedForCehckout: $selectedForCehckout)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CartGroup &&
        other.businessId == businessId &&
        other.businessBranchId == businessBranchId &&
        listEquals(other.cartItems, cartItems) &&
        other.selectedForCehckout == selectedForCehckout;
  }

  @override
  int get hashCode =>
      businessId.hashCode ^
      cartItems.hashCode ^
      selectedForCehckout.hashCode ^
      businessBranchId.hashCode;

  CartGroup copyWith({
    int? businessId,
    List<CartItem>? cartItems,
    bool? selectedForCehckout,
    int? businessBranchId,
  }) {
    return CartGroup(
      businessId: businessId ?? this.businessId,
      cartItems: cartItems ?? this.cartItems,
      selectedForCehckout: selectedForCehckout ?? this.selectedForCehckout,
      businessBranchId: businessBranchId ?? this.businessBranchId,
    );
  }
}
