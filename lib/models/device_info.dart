import 'dart:convert';
import 'package:hive_ce/hive.dart';

part 'device_info.g.dart';

@HiveType(typeId: 19)
class CustomDevInfo {
  @HiveField(0)
  String brand;
  @HiveField(1)
  String model;
  @HiveField(2)
  String baseOS;
  @HiveField(3)
  String error;
  @HiveField(4)
  String screen;

  CustomDevInfo({
    required this.brand,
    required this.model,
    required this.baseOS,
    this.screen = '',
    this.error = '',
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'brand': brand});
    result.addAll({'model': model});
    result.addAll({'baseOS': baseOS});
    result.addAll({'error': error});
    result.addAll({'screen': screen});

    return result;
  }

  factory CustomDevInfo.fromMap(Map<String, dynamic> map) {
    return CustomDevInfo(
      brand: map['brand'] ?? '',
      model: map['model'] ?? '',
      baseOS: map['baseOS'] ?? '',
      error: map['error'] ?? '',
      screen: map['screen'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => toMap();

  String toJsonString() => json.encode(toMap());

  factory CustomDevInfo.fromJson(Map<String, dynamic> json) =>
      CustomDevInfo.fromMap(json);

  factory CustomDevInfo.fromJsonString(String source) =>
      CustomDevInfo.fromMap(json.decode(source));

  CustomDevInfo copyWith({
    String? brand,
    String? model,
    String? baseOS,
    String? error,
    String? screen,
  }) {
    return CustomDevInfo(
      brand: brand ?? this.brand,
      model: model ?? this.model,
      baseOS: baseOS ?? this.baseOS,
      error: error ?? this.error,
      screen: screen ?? this.screen,
    );
  }
}
