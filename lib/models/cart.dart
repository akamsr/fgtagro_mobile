import 'dart:convert';
import 'package:hive_ce/hive.dart';
import 'package:fgtagro_mobile/models/cartitems.dart';

part 'cart.g.dart';

@HiveType(typeId: 8)
class Cart {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final int? userId;
  @HiveField(2)
  final String? sessionId;
  @HiveField(3)
  final bool selectedForCheckout;
  @HiveField(4)
  final int totalItems;
  @HiveField(5)
  final double subTotal;
  @HiveField(6)
  final double totalDiscount;
  @HiveField(7)
  final double grandTotal;
  @HiveField(8)
  final String? appliedCouponCode;
  @HiveField(9)
  final List<CartItem> items;
  @HiveField(10)
  final String? reservedAt;
  @HiveField(11)
  final String? expiresAt;

  Cart({
    required this.id,
    this.userId,
    this.sessionId,
    this.selectedForCheckout = false,
    this.totalItems = 0,
    this.subTotal = 0,
    this.totalDiscount = 0,
    this.grandTotal = 0,
    this.appliedCouponCode,
    this.items = const [],
    this.reservedAt,
    this.expiresAt,
  });

  factory Cart.fromMap(Map<String, dynamic> map) {
    return Cart(
      id: map['id']?.toInt() ?? 0,
      userId: map['userId']?.toInt(),
      sessionId: map['sessionId'],
      selectedForCheckout: map['selectedForCheckout'] ?? false,
      totalItems: map['totalItems']?.toInt() ?? 0,
      subTotal: map['subTotal']?.toDouble() ?? 0.0,
      totalDiscount: map['totalDiscount']?.toDouble() ?? 0.0,
      grandTotal: map['grandTotal']?.toDouble() ?? 0.0,
      appliedCouponCode: map['appliedCouponCode'],
      items:
          (map['items'] as List<dynamic>?)
              ?.map((e) => CartItem.fromMap(e))
              .toList() ??
          [],
      reservedAt: map['reservedAt'],
      expiresAt: map['expiresAt'],
    );
  }

  factory Cart.fromJson(Map<String, dynamic> json) => Cart.fromMap(json);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'sessionId': sessionId,
      'selectedForCheckout': selectedForCheckout,
      'totalItems': totalItems,
      'subTotal': subTotal,
      'totalDiscount': totalDiscount,
      'grandTotal': grandTotal,
      'appliedCouponCode': appliedCouponCode,
      'items': items.map((e) => e.toJson()).toList(),
      'reservedAt': reservedAt,
      'expiresAt': expiresAt,
    };
  }

  Map<String, dynamic> toJson() => toMap();

  String toJsonString() => json.encode(toMap());

  Cart copyWith({
    int? id,
    int? userId,
    String? sessionId,
    bool? selectedForCheckout,
    int? totalItems,
    double? subTotal,
    double? totalDiscount,
    double? grandTotal,
    String? appliedCouponCode,
    List<CartItem>? items,
    String? reservedAt,
    String? expiresAt,
  }) {
    return Cart(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      sessionId: sessionId ?? this.sessionId,
      selectedForCheckout: selectedForCheckout ?? this.selectedForCheckout,
      totalItems: totalItems ?? this.totalItems,
      subTotal: subTotal ?? this.subTotal,
      totalDiscount: totalDiscount ?? this.totalDiscount,
      grandTotal: grandTotal ?? this.grandTotal,
      appliedCouponCode: appliedCouponCode ?? this.appliedCouponCode,
      items: items ?? this.items,
      reservedAt: reservedAt ?? this.reservedAt,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }
}
