import 'package:hive_ce/hive.dart';

part 'payout_request.g.dart';

@HiveType(typeId: 40)
class PayoutRequestModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String walletId;
  @HiveField(2)
  final String sellerId;
  @HiveField(3)
  final double amount;
  @HiveField(4)
  final String payoutChannelOperator; // MTN_MOMO, ORANGE_MONEY
  @HiveField(5)
  final String destinationPhoneNumber;
  @HiveField(6)
  final String status; // pending, processing, completed, failed
  @HiveField(7)
  final DateTime createdAt;

  PayoutRequestModel({
    required this.id,
    required this.walletId,
    required this.sellerId,
    required this.amount,
    required this.payoutChannelOperator,
    required this.destinationPhoneNumber,
    required this.status,
    required this.createdAt,
  });

  factory PayoutRequestModel.fromJson(Map<String, dynamic> json) {
    return PayoutRequestModel(
      id: json['id']?.toString() ?? '',
      walletId: json['wallet_id']?.toString() ?? '',
      sellerId: json['seller_id']?.toString() ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      payoutChannelOperator: json['payout_channel_operator'] ?? 'MTN_MOMO',
      destinationPhoneNumber: json['destination_phone_number'] ?? '',
      status: json['status'] ?? 'pending',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'wallet_id': walletId,
      'seller_id': sellerId,
      'amount': amount,
      'payout_channel_operator': payoutChannelOperator,
      'destination_phone_number': destinationPhoneNumber,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
