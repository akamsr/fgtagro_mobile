// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_info.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomDevInfoAdapter extends TypeAdapter<CustomDevInfo> {
  @override
  final typeId = 19;

  @override
  CustomDevInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CustomDevInfo(
      brand: fields[0] as String,
      model: fields[1] as String,
      baseOS: fields[2] as String,
      screen: fields[4] == null ? '' : fields[4] as String,
      error: fields[3] == null ? '' : fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CustomDevInfo obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.brand)
      ..writeByte(1)
      ..write(obj.model)
      ..writeByte(2)
      ..write(obj.baseOS)
      ..writeByte(3)
      ..write(obj.error)
      ..writeByte(4)
      ..write(obj.screen);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomDevInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
