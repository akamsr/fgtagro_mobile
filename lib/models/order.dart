import 'package:fgtagro_mobile/models/cartitems.dart';
import 'package:hive_ce/hive.dart';

part 'order.g.dart';

@HiveType(typeId: 12)
enum OrderStatus {
  @HiveField(0)
  pending,
  @HiveField(1)
  processing,
  @HiveField(2)
  shipped,
  @HiveField(3)
  delivered,
  @HiveField(4)
  cancelled,
}

@HiveType(typeId: 11)
class OrderModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String orderNumber;
  @HiveField(2)
  final OrderStatus status;
  @HiveField(3)
  final double totalAmount;
  @HiveField(4)
  final DateTime createdAt;
  @HiveField(5)
  final List<CartItem> items;
  @HiveField(6)
  final String? shippingAddress;
  @HiveField(7)
  final String? paymentMethod;

  OrderModel({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.totalAmount,
    required this.createdAt,
    required this.items,
    this.shippingAddress,
    this.paymentMethod,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id']?.toString() ?? '',
      orderNumber: json['orderNumber'] ?? '',
      status: _parseOrderStatus(json['status']),
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      items: (json['items'] as List?)
              ?.map((e) => CartItem.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      shippingAddress: json['shippingAddress'],
      paymentMethod: json['paymentMethod'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderNumber': orderNumber,
      'status': status.name,
      'totalAmount': totalAmount,
      'createdAt': createdAt.toIso8601String(),
      'items': items.map((e) => e.toJson()).toList(),
      'shippingAddress': shippingAddress,
      'paymentMethod': paymentMethod,
    };
  }

  static OrderStatus _parseOrderStatus(dynamic value) {
    switch (value?.toString().toLowerCase()) {
      case 'processing':
        return OrderStatus.processing;
      case 'shipped':
        return OrderStatus.shipped;
      case 'delivered':
        return OrderStatus.delivered;
      case 'cancelled':
        return OrderStatus.cancelled;
      case 'pending':
      default:
        return OrderStatus.pending;
    }
  }

  OrderModel copyWith({
    String? id,
    String? orderNumber,
    OrderStatus? status,
    double? totalAmount,
    DateTime? createdAt,
    List<CartItem>? items,
    String? shippingAddress,
    String? paymentMethod,
  }) {
    return OrderModel(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      status: status ?? this.status,
      totalAmount: totalAmount ?? this.totalAmount,
      createdAt: createdAt ?? this.createdAt,
      items: items ?? this.items,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }
}
