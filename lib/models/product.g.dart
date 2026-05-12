// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductCategoryModelAdapter extends TypeAdapter<ProductCategoryModel> {
  @override
  final typeId = 5;

  @override
  ProductCategoryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductCategoryModel(
      id: fields[0] as String,
      name: fields[1] as String,
      slug: fields[2] as String,
      description: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ProductCategoryModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.slug)
      ..writeByte(3)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductCategoryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProductSellerModelAdapter extends TypeAdapter<ProductSellerModel> {
  @override
  final typeId = 6;

  @override
  ProductSellerModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductSellerModel(
      id: fields[0] as String,
      businessName: fields[1] as String,
      slug: fields[2] as String,
      status: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ProductSellerModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.businessName)
      ..writeByte(2)
      ..write(obj.slug)
      ..writeByte(3)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductSellerModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProductModelAdapter extends TypeAdapter<ProductModel> {
  @override
  final typeId = 4;

  @override
  ProductModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductModel(
      id: fields[0] as String,
      name: fields[1] as String,
      slug: fields[2] as String,
      shortDescription: fields[3] as String,
      description: fields[4] as String,
      unitPrice: (fields[5] as num).toDouble(),
      unitOfSale: fields[6] as String,
      stockQuantity: (fields[7] as num).toInt(),
      status: fields[8] as String,
      isFeatured: fields[9] as bool,
      isOnSale: fields[10] as bool,
      photos: (fields[11] as List).cast<String>(),
      keywords: (fields[12] as List).cast<String>(),
      category: fields[13] as ProductCategoryModel,
      seller: fields[14] as ProductSellerModel,
      publishedAt: fields[15] as String?,
      createdAt: fields[16] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ProductModel obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.slug)
      ..writeByte(3)
      ..write(obj.shortDescription)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.unitPrice)
      ..writeByte(6)
      ..write(obj.unitOfSale)
      ..writeByte(7)
      ..write(obj.stockQuantity)
      ..writeByte(8)
      ..write(obj.status)
      ..writeByte(9)
      ..write(obj.isFeatured)
      ..writeByte(10)
      ..write(obj.isOnSale)
      ..writeByte(11)
      ..write(obj.photos)
      ..writeByte(12)
      ..write(obj.keywords)
      ..writeByte(13)
      ..write(obj.category)
      ..writeByte(14)
      ..write(obj.seller)
      ..writeByte(15)
      ..write(obj.publishedAt)
      ..writeByte(16)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
