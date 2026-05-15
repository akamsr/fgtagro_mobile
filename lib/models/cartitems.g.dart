// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cartitems.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CartItemAdapter extends TypeAdapter<CartItem> {
  @override
  final typeId = 9;

  @override
  CartItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CartItem(
      id: (fields[0] as num).toInt(),
      productId: fields[1] as String?,
      restaurantItemId: (fields[2] as num?)?.toInt(),
      qty: (fields[3] as num).toInt(),
      businessId: (fields[4] as num).toInt(),
      size: fields[5] == null ? '' : fields[5] as String,
      color: fields[6] == null ? 'White' : fields[6] as String,
      type: fields[7] == null ? 'product' : fields[7] as String,
      discountId: (fields[8] as num?)?.toInt(),
      discountValue: (fields[9] as num?)?.toDouble(),
      originalPrice: fields[10] == null ? 0 : (fields[10] as num).toDouble(),
      finalPrice: fields[11] == null ? 0 : (fields[11] as num).toDouble(),
      shippingRateId: (fields[12] as num?)?.toInt(),
      productName: fields[13] as String?,
      productPhoto: fields[14] as String?,
      sellerName: fields[15] as String?,
      sellerCity: fields[16] as String?,
      availableStock: fields[17] == null ? 0 : (fields[17] as num).toInt(),
      unit: fields[18] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CartItem obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.productId)
      ..writeByte(2)
      ..write(obj.restaurantItemId)
      ..writeByte(3)
      ..write(obj.qty)
      ..writeByte(4)
      ..write(obj.businessId)
      ..writeByte(5)
      ..write(obj.size)
      ..writeByte(6)
      ..write(obj.color)
      ..writeByte(7)
      ..write(obj.type)
      ..writeByte(8)
      ..write(obj.discountId)
      ..writeByte(9)
      ..write(obj.discountValue)
      ..writeByte(10)
      ..write(obj.originalPrice)
      ..writeByte(11)
      ..write(obj.finalPrice)
      ..writeByte(12)
      ..write(obj.shippingRateId)
      ..writeByte(13)
      ..write(obj.productName)
      ..writeByte(14)
      ..write(obj.productPhoto)
      ..writeByte(15)
      ..write(obj.sellerName)
      ..writeByte(16)
      ..write(obj.sellerCity)
      ..writeByte(17)
      ..write(obj.availableStock)
      ..writeByte(18)
      ..write(obj.unit);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CartGroupAdapter extends TypeAdapter<CartGroup> {
  @override
  final typeId = 10;

  @override
  CartGroup read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CartGroup(
      businessId: (fields[0] as num).toInt(),
      cartItems: (fields[1] as List).cast<CartItem>(),
      selectedForCehckout: fields[2] as bool,
      businessBranchId: (fields[3] as num?)?.toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, CartGroup obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.businessId)
      ..writeByte(1)
      ..write(obj.cartItems)
      ..writeByte(2)
      ..write(obj.selectedForCehckout)
      ..writeByte(3)
      ..write(obj.businessBranchId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartGroupAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
