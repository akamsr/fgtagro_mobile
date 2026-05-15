import 'package:hive_ce/hive.dart';

part 'equipment.g.dart';

@HiveType(typeId: 30)
class EquipmentModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final List<String> photos;
  @HiveField(4)
  final double dailyRate;
  @HiveField(5)
  final double hourlyRate;
  @HiveField(6)
  final String category;
  @HiveField(7)
  final bool isAvailable;
  @HiveField(8)
  final String? condition;
  @HiveField(9)
  final String? model;
  @HiveField(10)
  final String? manufacturer;
  @HiveField(11)
  final double? gpsLatitude;
  @HiveField(12)
  final double? gpsLongitude;

  EquipmentModel({
    required this.id,
    required this.name,
    required this.description,
    required this.photos,
    required this.dailyRate,
    required this.hourlyRate,
    required this.category,
    this.isAvailable = true,
    this.condition,
    this.model,
    this.manufacturer,
    this.gpsLatitude,
    this.gpsLongitude,
  });

  factory EquipmentModel.fromJson(Map<String, dynamic> json) {
    return EquipmentModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      photos: List<String>.from(json['photos'] ?? []),
      dailyRate: (json['dailyRate'] ?? 0).toDouble(),
      hourlyRate: (json['hourlyRate'] ?? 0).toDouble(),
      category: json['category'] ?? '',
      isAvailable: json['isAvailable'] ?? true,
      condition: json['condition'],
      model: json['model'],
      manufacturer: json['manufacturer'],
      gpsLatitude: (json['gpsLatitude'] ?? 0).toDouble(),
      gpsLongitude: (json['gpsLongitude'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'photos': photos,
      'dailyRate': dailyRate,
      'hourlyRate': hourlyRate,
      'category': category,
      'isAvailable': isAvailable,
      'condition': condition,
      'model': model,
      'manufacturer': manufacturer,
      'gpsLatitude': gpsLatitude,
      'gpsLongitude': gpsLongitude,
    };
  }
}
