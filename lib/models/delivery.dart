import 'package:hive_ce/hive.dart';

part 'delivery.g.dart';

@HiveType(typeId: 29)
class DeliveryModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String orderId;
  @HiveField(2)
  final String? driverId;
  @HiveField(3)
  final String trackingNumber;
  @HiveField(4)
  final String status; // assigned, accepted, picked_up, in_transit, arrived, delivered, failed
  @HiveField(5)
  final double? currentGpsLatitude;
  @HiveField(6)
  final double? currentGpsLongitude;
  @HiveField(7)
  final String? deliverySignature;
  @HiveField(8)
  final List<String> deliveryPhotos;
  @HiveField(9)
  final int attemptCount;
  @HiveField(10)
  final DateTime createdAt;

  DeliveryModel({
    required this.id,
    required this.orderId,
    this.driverId,
    required this.trackingNumber,
    required this.status,
    this.currentGpsLatitude,
    this.currentGpsLongitude,
    this.deliverySignature,
    this.deliveryPhotos = const [],
    this.attemptCount = 0,
    required this.createdAt,
  });

  factory DeliveryModel.fromJson(Map<String, dynamic> json) {
    return DeliveryModel(
      id: json['id']?.toString() ?? '',
      orderId: json['order_id']?.toString() ?? '',
      driverId: json['driver_id']?.toString(),
      trackingNumber: json['tracking_number'] ?? '',
      status: json['status'] ?? 'assigned',
      currentGpsLatitude: json['current_gps_latitude'] != null ? double.tryParse(json['current_gps_latitude'].toString()) : null,
      currentGpsLongitude: json['current_gps_longitude'] != null ? double.tryParse(json['current_gps_longitude'].toString()) : null,
      deliverySignature: json['delivery_signature'],
      deliveryPhotos: json['delivery_photos'] != null ? List<String>.from(json['delivery_photos']) : [],
      attemptCount: json['attempt_count'] ?? 0,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'driver_id': driverId,
      'tracking_number': trackingNumber,
      'status': status,
      'current_gps_latitude': currentGpsLatitude,
      'current_gps_longitude': currentGpsLongitude,
      'delivery_signature': deliverySignature,
      'delivery_photos': deliveryPhotos,
      'attempt_count': attemptCount,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
