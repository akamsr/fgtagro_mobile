import 'package:hive_ce/hive.dart';

part 'payment.g.dart';

@HiveType(typeId: 27)
class PaymentModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String orderId;
  @HiveField(2)
  final double amount;
  @HiveField(3)
  final String currency;
  @HiveField(4)
  final String paymentMethod;
  @HiveField(5)
  final String? gatewayReference;
  @HiveField(6)
  final String transactionStatus; // pending, completed, failed
  @HiveField(7)
  final String escrowStatus; // held, released, refunded
  @HiveField(8)
  final DateTime? escrowReleasedAt;
  @HiveField(9)
  final DateTime? escrowRefundedAt;
  @HiveField(10)
  final DateTime createdAt;

  PaymentModel({
    required this.id,
    required this.orderId,
    required this.amount,
    required this.currency,
    required this.paymentMethod,
    this.gatewayReference,
    required this.transactionStatus,
    required this.escrowStatus,
    this.escrowReleasedAt,
    this.escrowRefundedAt,
    required this.createdAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id']?.toString() ?? '',
      orderId: json['order_id']?.toString() ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'XAF',
      paymentMethod: json['payment_method'] ?? '',
      gatewayReference: json['gateway_reference']?.toString(),
      transactionStatus: json['transaction_status'] ?? 'pending',
      escrowStatus: json['escrow_status'] ?? 'held',
      escrowReleasedAt: json['escrow_released_at'] != null ? DateTime.tryParse(json['escrow_released_at']) : null,
      escrowRefundedAt: json['escrow_refunded_at'] != null ? DateTime.tryParse(json['escrow_refunded_at']) : null,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'amount': amount,
      'currency': currency,
      'payment_method': paymentMethod,
      'gateway_reference': gatewayReference,
      'transaction_status': transactionStatus,
      'escrow_status': escrowStatus,
      'escrow_released_at': escrowReleasedAt?.toIso8601String(),
      'escrow_refunded_at': escrowRefundedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}
