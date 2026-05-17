import 'package:hive_ce/hive.dart';

part 'rbac.g.dart';

@HiveType(typeId: 22)
class PermissionModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name; // e.g. products.create
  @HiveField(2)
  final String? description;

  PermissionModel({
    required this.id,
    required this.name,
    this.description,
  });

  factory PermissionModel.fromJson(Map<String, dynamic> json) {
    return PermissionModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }
}

@HiveType(typeId: 23)
class RoleModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name; // e.g. super_admin, seller
  @HiveField(2)
  final bool isSystem;

  RoleModel({
    required this.id,
    required this.name,
    this.isSystem = false,
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    return RoleModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      isSystem: json['is_system'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'is_system': isSystem,
    };
  }
}

@HiveType(typeId: 24)
class RolePermissionModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String roleId;
  @HiveField(2)
  final String permissionId;

  RolePermissionModel({
    required this.id,
    required this.roleId,
    required this.permissionId,
  });

  factory RolePermissionModel.fromJson(Map<String, dynamic> json) {
    return RolePermissionModel(
      id: json['id']?.toString() ?? '',
      roleId: json['role_id']?.toString() ?? '',
      permissionId: json['permission_id']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role_id': roleId,
      'permission_id': permissionId,
    };
  }
}

@HiveType(typeId: 25)
class UserRoleModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String userId;
  @HiveField(2)
  final String roleId;
  @HiveField(3)
  final DateTime? expiresAt;
  @HiveField(4)
  final String? grantedBy;

  UserRoleModel({
    required this.id,
    required this.userId,
    required this.roleId,
    this.expiresAt,
    this.grantedBy,
  });

  factory UserRoleModel.fromJson(Map<String, dynamic> json) {
    return UserRoleModel(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      roleId: json['role_id']?.toString() ?? '',
      expiresAt: json['expires_at'] != null ? DateTime.tryParse(json['expires_at']) : null,
      grantedBy: json['granted_by']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'role_id': roleId,
      'expires_at': expiresAt?.toIso8601String(),
      'granted_by': grantedBy,
    };
  }
}
