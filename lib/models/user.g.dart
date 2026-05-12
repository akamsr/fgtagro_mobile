// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final typeId = 0;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      uid: fields[2] == null ? '' : fields[2] as String,
      id: (fields[0] as num?)?.toInt(),
      expireIn: (fields[1] as num?)?.toInt(),
      fullNames: fields[3] as String?,
      roles: fields[4] == null
          ? const []
          : (fields[4] as List?)?.cast<dynamic>(),
      email: fields[6] as String?,
      phoneNumber: fields[7] as String?,
      photoUrl: fields[8] as String?,
      provider: fields[9] == null ? '' : fields[9] as String,
      token: fields[10] as String?,
      regionCityAdress: fields[12] == null ? '' : fields[12] as String,
      interest: fields[5] == null
          ? const []
          : (fields[5] as List?)?.cast<dynamic>(),
      deviceToken: fields[11] as String?,
      createdAt: fields[13] as String?,
      updatedAt: fields[14] as String?,
      ambassadorId: fields[16] as String?,
      deviceId: fields[17] == null ? '' : fields[17] as String,
      refreshToken: fields[18] == null ? '' : fields[18] as String,
      password: fields[19] == null ? '' : fields[19] as String,
      agentId: (fields[15] as num?)?.toInt(),
      role: fields[20] as UserRole?,
      is_online: fields[21] == null ? false : fields[21] as bool,
      last_seen: fields[22] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(23)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.expireIn)
      ..writeByte(2)
      ..write(obj.uid)
      ..writeByte(3)
      ..write(obj.fullNames)
      ..writeByte(4)
      ..write(obj.roles)
      ..writeByte(5)
      ..write(obj.interest)
      ..writeByte(6)
      ..write(obj.email)
      ..writeByte(7)
      ..write(obj.phoneNumber)
      ..writeByte(8)
      ..write(obj.photoUrl)
      ..writeByte(9)
      ..write(obj.provider)
      ..writeByte(10)
      ..write(obj.token)
      ..writeByte(11)
      ..write(obj.deviceToken)
      ..writeByte(12)
      ..write(obj.regionCityAdress)
      ..writeByte(13)
      ..write(obj.createdAt)
      ..writeByte(14)
      ..write(obj.updatedAt)
      ..writeByte(15)
      ..write(obj.agentId)
      ..writeByte(16)
      ..write(obj.ambassadorId)
      ..writeByte(17)
      ..write(obj.deviceId)
      ..writeByte(18)
      ..write(obj.refreshToken)
      ..writeByte(19)
      ..write(obj.password)
      ..writeByte(20)
      ..write(obj.role)
      ..writeByte(21)
      ..write(obj.is_online)
      ..writeByte(22)
      ..write(obj.last_seen);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserRoleAdapter extends TypeAdapter<UserRole> {
  @override
  final typeId = 1;

  @override
  UserRole read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return UserRole.shopper;
      case 1:
        return UserRole.businessStaff;
      case 2:
        return UserRole.business;
      case 3:
        return UserRole.deliveryPartnerAdmin;
      case 4:
        return UserRole.dispatcher;
      case 5:
        return UserRole.deliveryAgent;
      case 6:
        return UserRole.deliveryAccountant;
      case 7:
        return UserRole.buzmeEmployee;
      default:
        return UserRole.shopper;
    }
  }

  @override
  void write(BinaryWriter writer, UserRole obj) {
    switch (obj) {
      case UserRole.shopper:
        writer.writeByte(0);
      case UserRole.businessStaff:
        writer.writeByte(1);
      case UserRole.business:
        writer.writeByte(2);
      case UserRole.deliveryPartnerAdmin:
        writer.writeByte(3);
      case UserRole.dispatcher:
        writer.writeByte(4);
      case UserRole.deliveryAgent:
        writer.writeByte(5);
      case UserRole.deliveryAccountant:
        writer.writeByte(6);
      case UserRole.buzmeEmployee:
        writer.writeByte(7);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserRoleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
