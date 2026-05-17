import 'package:hive_ce/hive.dart';

part 'wallet.g.dart';

@HiveType(typeId: 38)
class WalletModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String sellerId;
  @HiveField(2)
  final double balance;
  @HiveField(3)
  final double pendingBalance;
  @HiveField(4)
  final double totalEarned;
  @HiveField(5)
  final double totalPaidOut;

  WalletModel({
    required this.id,
    required this.sellerId,
    this.balance = 0.0,
    this.pendingBalance = 0.0,
    this.totalEarned = 0.0,
    this.totalPaidOut = 0.0,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json['id']?.toString() ?? '',
      sellerId: json['seller_id']?.toString() ?? '',
      balance: (json['balance'] ?? 0.0).toDouble(),
      pendingBalance: (json['pending_balance'] ?? 0.0).toDouble(),
      totalEarned: (json['total_earned'] ?? 0.0).toDouble(),
      totalPaidOut: (json['total_paid_out'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'seller_id': sellerId,
      'balance': balance,
      'pending_balance': pendingBalance,
      'total_earned': totalEarned,
      'total_paid_out': totalPaidOut,
    };
  }
}

@HiveType(typeId: 39)
class WalletTransactionModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String walletId;
  @HiveField(2)
  final String type; // escrow_release, payout, commission_reversal, adjustment
  @HiveField(3)
  final double amount;
  @HiveField(4)
  final double balanceAfter;
  @HiveField(5)
  final String? linkedOrderId;
  @HiveField(6)
  final DateTime createdAt;

  WalletTransactionModel({
    required this.id,
    required this.walletId,
    required this.type,
    required this.amount,
    required this.balanceAfter,
    this.linkedOrderId,
    required this.createdAt,
  });

  factory WalletTransactionModel.fromJson(Map<String, dynamic> json) {
    return WalletTransactionModel(
      id: json['id']?.toString() ?? '',
      walletId: json['wallet_id']?.toString() ?? '',
      type: json['type'] ?? 'escrow_release',
      amount: (json['amount'] ?? 0.0).toDouble(),
      balanceAfter: (json['balance_after'] ?? 0.0).toDouble(),
      linkedOrderId: json['linked_order_id']?.toString(),
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'wallet_id': walletId,
      'type': type,
      'amount': amount,
      'balance_after': balanceAfter,
      'linked_order_id': linkedOrderId,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
