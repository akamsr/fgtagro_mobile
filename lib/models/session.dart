import 'package:hive_ce/hive.dart';

part 'session.g.dart';

@HiveType(typeId: 37)
class AccessTokenModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String userId;
  @HiveField(2)
  final String tokenHash;
  @HiveField(3)
  final String? deviceId;
  @HiveField(4)
  final String? ipAddress;
  @HiveField(5)
  final DateTime expiresAt;
  @HiveField(6)
  final bool revoked;
  @HiveField(7)
  final bool biometricEnabled;

  AccessTokenModel({
    required this.id,
    required this.userId,
    required this.tokenHash,
    this.deviceId,
    this.ipAddress,
    required this.expiresAt,
    this.revoked = false,
    this.biometricEnabled = false,
  });

  factory AccessTokenModel.fromJson(Map<String, dynamic> json) {
    return AccessTokenModel(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      tokenHash: json['token_hash'] ?? '',
      deviceId: json['device_id']?.toString(),
      ipAddress: json['ip_address'],
      expiresAt: DateTime.tryParse(json['expires_at'] ?? '') ?? DateTime.now(),
      revoked: json['revoked'] ?? false,
      biometricEnabled: json['biometric_enabled'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'token_hash': tokenHash,
      'device_id': deviceId,
      'ip_address': ipAddress,
      'expires_at': expiresAt.toIso8601String(),
      'revoked': revoked,
      'biometric_enabled': biometricEnabled,
    };
  }
}

@HiveType(typeId: 20)
class RefreshTokenModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String userId;
  @HiveField(2)
  final String tokenHash;
  @HiveField(3)
  final String? tokenFamilyId;
  @HiveField(4)
  final DateTime expiresAt;
  @HiveField(5)
  final bool revoked;

  RefreshTokenModel({
    required this.id,
    required this.userId,
    required this.tokenHash,
    this.tokenFamilyId,
    required this.expiresAt,
    this.revoked = false,
  });

  factory RefreshTokenModel.fromJson(Map<String, dynamic> json) {
    return RefreshTokenModel(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      tokenHash: json['token_hash'] ?? '',
      tokenFamilyId: json['token_family_id']?.toString(),
      expiresAt: DateTime.tryParse(json['expires_at'] ?? '') ?? DateTime.now(),
      revoked: json['revoked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'token_hash': tokenHash,
      'token_family_id': tokenFamilyId,
      'expires_at': expiresAt.toIso8601String(),
      'revoked': revoked,
    };
  }
}
