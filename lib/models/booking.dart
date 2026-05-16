import 'package:fgtagro_mobile/models/equipment.dart';
import 'package:fgtagro_mobile/models/user.dart';
import 'package:hive_ce/hive.dart';

part 'booking.g.dart';

@HiveType(typeId: 32)
class BookingModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final EquipmentModel equipment;
  @HiveField(2)
  final UserModel tenant;
  @HiveField(3)
  final DateTime startDate;
  @HiveField(4)
  final DateTime endDate;
  @HiveField(5)
  final double totalAmount;
  @HiveField(6)
  final String status; // PENDING, ACTIVE, COMPLETED, CANCELLED
  @HiveField(7)
  final String? rejectionReason;
  @HiveField(8)
  final DateTime createdAt;

  BookingModel({
    required this.id,
    required this.equipment,
    required this.tenant,
    required this.startDate,
    required this.endDate,
    required this.totalAmount,
    required this.status,
    this.rejectionReason,
    required this.createdAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id']?.toString() ?? '',
      equipment: EquipmentModel.fromJson(json['equipment']),
      tenant: UserModel.fromJson(json['tenant']),
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      status: json['status'] ?? 'PENDING',
      rejectionReason: json['rejectionReason'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'equipment': equipment.toJson(),
      'tenant': tenant.toJson(),
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'totalAmount': totalAmount,
      'status': status,
      'rejectionReason': rejectionReason,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
