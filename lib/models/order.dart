import 'package:fgtagro_mobile/models/cartitems.dart';
import 'package:hive_ce/hive.dart';

part 'order.g.dart';

@HiveType(typeId: 12)
enum OrderStatus {
  // ── Payment states ──
  @HiveField(0)
  paymentPending,
  @HiveField(1)
  paymentConfirmed,
  @HiveField(2)
  paymentFailed,
  // ── Legacy alias kept for backward compat ──
  @HiveField(3)
  pending, // same as paymentPending
  // ── Fulfillment states ──
  @HiveField(4)
  preparing,
  @HiveField(5)
  driverAssigned,
  @HiveField(6)
  pickedUp,
  @HiveField(7)
  outForDelivery,
  @HiveField(8)
  shipped, // alias for outForDelivery
  // ── Store pickup branch ──
  @HiveField(9)
  readyForPickup,
  // ── Success states ──
  @HiveField(10)
  delivered,
  @HiveField(11)
  completed,
  // ── Cancellation states ──
  @HiveField(12)
  cancelledByBuyer,
  @HiveField(13)
  cancelledAuto,
  @HiveField(14)
  cancelledByAdmin,
  @HiveField(15)
  cancelled, // generic fallback
  @HiveField(16)
  expired,
  @HiveField(17)
  deliveryFailed,
  @HiveField(18)
  pickupExpired,
  // ── Dispute / refund states ──
  @HiveField(19)
  refundRequested,
  @HiveField(20)
  refunded,
  @HiveField(21)
  refundRejected,
}

extension OrderStatusHelpers on OrderStatus {
  bool get isActive => const {
        OrderStatus.paymentPending,
        OrderStatus.pending,
        OrderStatus.paymentConfirmed,
        OrderStatus.preparing,
        OrderStatus.driverAssigned,
        OrderStatus.pickedUp,
        OrderStatus.outForDelivery,
        OrderStatus.shipped,
        OrderStatus.readyForPickup,
        OrderStatus.delivered,
      }.contains(this);

  bool get isCompleted => this == OrderStatus.completed;

  bool get isCancelled => const {
        OrderStatus.cancelledByBuyer,
        OrderStatus.cancelledAuto,
        OrderStatus.cancelledByAdmin,
        OrderStatus.cancelled,
        OrderStatus.expired,
        OrderStatus.paymentFailed,
        OrderStatus.deliveryFailed,
        OrderStatus.pickupExpired,
      }.contains(this);

  bool get isRefundable => const {
        OrderStatus.refundRequested,
        OrderStatus.refunded,
        OrderStatus.refundRejected,
      }.contains(this);

  bool get canCancel => const {
        OrderStatus.paymentPending,
        OrderStatus.pending,
        OrderStatus.paymentConfirmed,
      }.contains(this);

  bool get canDispute => this == OrderStatus.delivered || this == OrderStatus.completed;

  bool get canTrack => const {
        OrderStatus.pickedUp,
        OrderStatus.outForDelivery,
        OrderStatus.shipped,
      }.contains(this);
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

  @HiveField(21)
  final String? slug;
  @HiveField(22)
  final String? buyerId;
  @HiveField(23)
  final double subtotalAmount;
  @HiveField(24)
  final double deliveryFee;
  @HiveField(25)
  final double discountAmount;
  @HiveField(26)
  final double taxAmount;
  @HiveField(27)
  final String? fulfillmentType;
  @HiveField(28)
  final DateTime? pickupDeadline;
  @HiveField(29)
  final String? driverId;

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
    this.slug,
    this.buyerId,
    this.subtotalAmount = 0.0,
    this.deliveryFee = 0.0,
    this.discountAmount = 0.0,
    this.taxAmount = 0.0,
    this.fulfillmentType,
    this.pickupDeadline,
    this.driverId,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id']?.toString() ?? '',
      orderNumber: json['order_number'] ?? json['orderNumber'] ?? '',
      status: _parseOrderStatus(json['status']),
      totalAmount: (json['total_amount'] ?? json['totalAmount'] ?? 0).toDouble(),
      createdAt: DateTime.tryParse(json['created_at'] ?? json['createdAt'] ?? '') ?? DateTime.now(),
      items: (json['items'] as List?)
              ?.map((e) => CartItem.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      shippingAddress: json['shippingAddress'] ?? json['delivery_details']?['address'],
      paymentMethod: json['paymentMethod'] ?? json['payment_method_details']?['method'],
      customerName: json['customerName'] ?? json['buyer']?['fullNames'],
      deliveryMethod: json['deliveryMethod'] ?? json['fulfillment_type'] ?? 'HOME_DELIVERY',
      buyerCity: json['buyerCity'] ?? json['delivery_details']?['city'],
      buyerNeighborhood: json['buyerNeighborhood'] ?? json['delivery_details']?['neighborhood'],
      driverName: json['driverName'] ?? json['driver']?['fullNames'],
      driverPhone: json['driverPhone'] ?? json['driver']?['phoneNumber'],
      storeName: json['storeName'] ?? json['store']?['name'],
      storeAddress: json['storeAddress'] ?? json['store']?['address'],
      timeline: (json['timeline'] as Map?)?.map(
            (k, v) => MapEntry(_parseOrderStatus(k), DateTime.parse(v)),
          ) ??
          {},
      cancellationReason: json['cancellationReason'] ?? json['cancelled_at']?.toString(),
      payoutAmount: (json['payoutAmount'] as num?)?.toDouble(),
      payoutDate: json['payoutDate'] != null ? DateTime.parse(json['payoutDate']) : null,
      paymentStatus: json['paymentStatus'] ?? 'PAID',
      slug: json['slug'],
      buyerId: json['buyer_id']?.toString(),
      subtotalAmount: (json['subtotal_amount'] ?? 0).toDouble(),
      deliveryFee: (json['delivery_fee'] ?? 0).toDouble(),
      discountAmount: (json['discount_amount'] ?? 0).toDouble(),
      taxAmount: (json['tax_amount'] ?? 0).toDouble(),
      fulfillmentType: json['fulfillment_type'] ?? json['deliveryMethod'],
      pickupDeadline: json['pickup_deadline'] != null ? DateTime.tryParse(json['pickup_deadline']) : null,
      driverId: json['driver_id']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderNumber': orderNumber,
      'order_number': orderNumber,
      'status': status.name,
      'totalAmount': totalAmount,
      'total_amount': totalAmount,
      'createdAt': createdAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
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
      'slug': slug,
      'buyer_id': buyerId,
      'subtotal_amount': subtotalAmount,
      'delivery_fee': deliveryFee,
      'discount_amount': discountAmount,
      'tax_amount': taxAmount,
      'fulfillment_type': fulfillmentType,
      'pickup_deadline': pickupDeadline?.toIso8601String(),
      'driver_id': driverId,
    };
  }

  static OrderStatus _parseOrderStatus(dynamic value) {
    switch (value?.toString().toLowerCase()) {
      case 'payment_pending':
        return OrderStatus.paymentPending;
      case 'payment_confirmed':
        return OrderStatus.paymentConfirmed;
      case 'payment_failed':
        return OrderStatus.paymentFailed;
      case 'preparing':
      case 'processing':
        return OrderStatus.preparing;
      case 'driver_assigned':
        return OrderStatus.driverAssigned;
      case 'picked_up':
        return OrderStatus.pickedUp;
      case 'out_for_delivery':
        return OrderStatus.outForDelivery;
      case 'shipped':
        return OrderStatus.shipped;
      case 'ready_for_pickup':
        return OrderStatus.readyForPickup;
      case 'delivered':
        return OrderStatus.delivered;
      case 'completed':
        return OrderStatus.completed;
      case 'cancelled_by_buyer':
        return OrderStatus.cancelledByBuyer;
      case 'cancelled_auto':
        return OrderStatus.cancelledAuto;
      case 'cancelled_by_admin':
        return OrderStatus.cancelledByAdmin;
      case 'cancelled':
        return OrderStatus.cancelled;
      case 'expired':
        return OrderStatus.expired;
      case 'delivery_failed':
        return OrderStatus.deliveryFailed;
      case 'pickup_expired':
        return OrderStatus.pickupExpired;
      case 'refund_requested':
        return OrderStatus.refundRequested;
      case 'refunded':
        return OrderStatus.refunded;
      case 'refund_rejected':
        return OrderStatus.refundRejected;
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
    String? slug,
    String? buyerId,
    double? subtotalAmount,
    double? deliveryFee,
    double? discountAmount,
    double? taxAmount,
    String? fulfillmentType,
    DateTime? pickupDeadline,
    String? driverId,
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
      slug: slug ?? this.slug,
      buyerId: buyerId ?? this.buyerId,
      subtotalAmount: subtotalAmount ?? this.subtotalAmount,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      discountAmount: discountAmount ?? this.discountAmount,
      taxAmount: taxAmount ?? this.taxAmount,
      fulfillmentType: fulfillmentType ?? this.fulfillmentType,
      pickupDeadline: pickupDeadline ?? this.pickupDeadline,
      driverId: driverId ?? this.driverId,
    );
  }
}
