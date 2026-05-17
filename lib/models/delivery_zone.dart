import 'package:hive_ce/hive.dart';

part 'delivery_zone.g.dart';

@HiveType(typeId: 28)
class DeliveryZoneModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String code;
  @HiveField(2)
  final String name;
  @HiveField(3)
  final String city;
  @HiveField(4)
  final Map<String, dynamic>? boundary; // GeoJSON representation
  @HiveField(5)
  final double baseShippingFee;
  @HiveField(6)
  final double feePerKilometer;
  @HiveField(7)
  final double? maxWeightKg;
  @HiveField(8)
  final String? sameDayCutoff;

  DeliveryZoneModel({
    required this.id,
    required this.code,
    required this.name,
    required this.city,
    this.boundary,
    required this.baseShippingFee,
    required this.feePerKilometer,
    this.maxWeightKg,
    this.sameDayCutoff,
  });

  factory DeliveryZoneModel.fromJson(Map<String, dynamic> json) {
    return DeliveryZoneModel(
      id: json['id']?.toString() ?? '',
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      city: json['city'] ?? '',
      boundary: json['boundary'] is Map ? Map<String, dynamic>.from(json['boundary']) : null,
      baseShippingFee: (json['base_shipping_fee'] ?? 0.0).toDouble(),
      feePerKilometer: (json['fee_per_kilometer'] ?? 0.0).toDouble(),
      maxWeightKg: json['max_weight_kg'] != null ? (json['max_weight_kg'] as num).toDouble() : null,
      sameDayCutoff: json['same_day_cutoff'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'city': city,
      'boundary': boundary,
      'base_shipping_fee': baseShippingFee,
      'fee_per_kilometer': feePerKilometer,
      'max_weight_kg': maxWeightKg,
      'same_day_cutoff': sameDayCutoff,
    };
  }
}
