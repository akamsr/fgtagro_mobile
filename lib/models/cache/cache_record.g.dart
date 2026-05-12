// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cache_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CacheRecordAdapter extends TypeAdapter<CacheRecord> {
  @override
  final typeId = 50;

  @override
  CacheRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CacheRecord(
      url: fields[0] as String,
      responseData: fields[1] as String,
      timestamp: fields[2] as DateTime,
      headers: (fields[3] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, CacheRecord obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.url)
      ..writeByte(1)
      ..write(obj.responseData)
      ..writeByte(2)
      ..write(obj.timestamp)
      ..writeByte(3)
      ..write(obj.headers);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CacheRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
