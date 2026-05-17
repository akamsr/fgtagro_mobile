import 'package:hive_ce/hive.dart';

part 'device_biometric.g.dart';

@HiveType(typeId: 21)
class DeviceBiometricModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String userId;
  @HiveField(2)
  final String deviceId;
  @HiveField(3)
  final String biometricType; // face_id, touch_id, etc.
  @HiveField(4)
  final String publicKey;
  @HiveField(5)
  final bool isEnabled;

  DeviceBiometricModel({
    required this.id,
    required this.userId,
    required this.deviceId,
    required this.biometricType,
    required this.publicKey,
    this.isEnabled = true,
  });

  factory DeviceBiometricModel.fromJson(Map<String, dynamic> json) {
    return DeviceBiometricModel(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      deviceId: json['device_id']?.toString() ?? '',
      biometricType: json['biometric_type'] ?? 'face_id',
      publicKey: json['public_key'] ?? '',
      isEnabled: json['is_enabled'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'device_id': deviceId,
      'biometric_type': biometricType,
      'public_key': publicKey,
      'is_enabled': isEnabled,
    };
  }
}
