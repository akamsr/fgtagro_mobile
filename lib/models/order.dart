import 'package:fgtagro_mobile/models/cartitems.dart';
import 'package:hive_ce/hive.dart';

part 'order.g.dart';

@HiveType(typeId: 12)
enum OrderStatus {
  @HiveField(0)
  pending,
  @HiveField(1)
  preparing,
  @HiveField(2)
  shipped,
  @HiveField(3)
  delivered,
  @HiveField(4)
  cancelled,
  @HiveField(5)
  paymentConfirmed,
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
  @HiveField(8)
  final String? customerName;
  @HiveField(9)
  final String deliveryMethod; // HOME_DELIVERY or STORE_PICKUP
  @HiveField(10)
  final String? buyerCity;
  @HiveField(11)
  final String? buyerNeighborhood;
  @HiveField(12)
  final String? driverName;
  @HiveField(13)
  final String? driverPhone;
  @HiveField(14)
  final String? storeName;
  @HiveField(15)
  final String? storeAddress;
  @HiveField(16)
  final Map<OrderStatus, DateTime> timeline;
  @HiveField(17)
  final String? cancellationReason;
  @HiveField(18)
  final double? payoutAmount;
  @HiveField(19)
  final DateTime? payoutDate;
  @HiveField(20)
  final String paymentStatus;

  OrderModel({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.totalAmount,
    required this.createdAt,
    required this.items,
    this.shippingAddress,
    this.paymentMethod,
    this.customerName,
    this.deliveryMethod = 'HOME_DELIVERY',
    this.buyerCity,
    this.buyerNeighborhood,
    this.driverName,
    this.driverPhone,
    this.storeName,
    this.storeAddress,
    this.timeline = const {},
    this.cancellationReason,
    this.payoutAmount,
    this.payoutDate,
    this.paymentStatus = 'PAID',
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
      customerName: json['customerName'],
      deliveryMethod: json['deliveryMethod'] ?? 'HOME_DELIVERY',
      buyerCity: json['buyerCity'],
      buyerNeighborhood: json['buyerNeighborhood'],
      driverName: json['driverName'],
      driverPhone: json['driverPhone'],
      storeName: json['storeName'],
      storeAddress: json['storeAddress'],
      timeline: (json['timeline'] as Map?)?.map(
            (k, v) => MapEntry(_parseOrderStatus(k), DateTime.parse(v)),
          ) ??
          {},
      cancellationReason: json['cancellationReason'],
      payoutAmount: (json['payoutAmount'] as num?)?.toDouble(),
      payoutDate: json['payoutDate'] != null ? DateTime.parse(json['payoutDate']) : null,
      paymentStatus: json['paymentStatus'] ?? 'PAID',
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
      'customerName': customerName,
      'deliveryMethod': deliveryMethod,
      'buyerCity': buyerCity,
      'buyerNeighborhood': buyerNeighborhood,
      'driverName': driverName,
      'driverPhone': driverPhone,
      'storeName': storeName,
      'storeAddress': storeAddress,
      'timeline': timeline.map((k, v) => MapEntry(k.name, v.toIso8601String())),
      'cancellationReason': cancellationReason,
      'payoutAmount': payoutAmount,
      'payoutDate': payoutDate?.toIso8601String(),
      'paymentStatus': paymentStatus,
    };
  }

  static OrderStatus _parseOrderStatus(dynamic value) {
    switch (value?.toString().toLowerCase()) {
      case 'preparing':
      case 'processing':
        return OrderStatus.preparing;
      case 'shipped':
        return OrderStatus.shipped;
      case 'delivered':
        return OrderStatus.delivered;
      case 'cancelled':
        return OrderStatus.cancelled;
      case 'payment_confirmed':
        return OrderStatus.paymentConfirmed;
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
    String? customerName,
    String? deliveryMethod,
    String? buyerCity,
    String? buyerNeighborhood,
    String? driverName,
    String? driverPhone,
    String? storeName,
    String? storeAddress,
    Map<OrderStatus, DateTime>? timeline,
    String? cancellationReason,
    double? payoutAmount,
    DateTime? payoutDate,
    String? paymentStatus,
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
      customerName: customerName ?? this.customerName,
      deliveryMethod: deliveryMethod ?? this.deliveryMethod,
      buyerCity: buyerCity ?? this.buyerCity,
      buyerNeighborhood: buyerNeighborhood ?? this.buyerNeighborhood,
      driverName: driverName ?? this.driverName,
      driverPhone: driverPhone ?? this.driverPhone,
      storeName: storeName ?? this.storeName,
      storeAddress: storeAddress ?? this.storeAddress,
      timeline: timeline ?? this.timeline,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      payoutAmount: payoutAmount ?? this.payoutAmount,
      payoutDate: payoutDate ?? this.payoutDate,
      paymentStatus: paymentStatus ?? this.paymentStatus,
    );
  }
}
