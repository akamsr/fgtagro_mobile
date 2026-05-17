// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CategoryModelAdapter extends TypeAdapter<CategoryModel> {
  @override
  final typeId = 7;

  @override
  CategoryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CategoryModel(
      id: fields[0] as String,
      name: fields[1] as String,
      slug: fields[2] as String,
      description: fields[3] as String?,
      icon: fields[4] as String?,
      parentId: fields[5] as String?,
      commissionRate: fields[6] == null ? 0.0 : (fields[6] as num).toDouble(),
      vatRate: fields[7] == null ? 0.0 : (fields[7] as num).toDouble(),
      isReturnable: fields[8] == null ? true : fields[8] as bool,
      maxReturnDays: fields[9] == null ? 30 : (fields[9] as num).toInt(),
      requiresPhysicalInspection: fields[10] == null
          ? false
          : fields[10] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, CategoryModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.slug)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.icon)
      ..writeByte(5)
      ..write(obj.parentId)
      ..writeByte(6)
      ..write(obj.commissionRate)
      ..writeByte(7)
      ..write(obj.vatRate)
      ..writeByte(8)
      ..write(obj.isReturnable)
      ..writeByte(9)
      ..write(obj.maxReturnDays)
      ..writeByte(10)
      ..write(obj.requiresPhysicalInspection);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
