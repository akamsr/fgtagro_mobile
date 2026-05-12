// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CartAdapter extends TypeAdapter<Cart> {
  @override
  final typeId = 8;

  @override
  Cart read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Cart(
      id: (fields[0] as num).toInt(),
      userId: (fields[1] as num?)?.toInt(),
      sessionId: fields[2] as String?,
      selectedForCheckout: fields[3] == null ? false : fields[3] as bool,
      totalItems: fields[4] == null ? 0 : (fields[4] as num).toInt(),
      subTotal: fields[5] == null ? 0 : (fields[5] as num).toDouble(),
      totalDiscount: fields[6] == null ? 0 : (fields[6] as num).toDouble(),
      grandTotal: fields[7] == null ? 0 : (fields[7] as num).toDouble(),
      appliedCouponCode: fields[8] as String?,
      items: fields[9] == null
          ? const []
          : (fields[9] as List).cast<CartItem>(),
    );
  }

  @override
  void write(BinaryWriter writer, Cart obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.sessionId)
      ..writeByte(3)
      ..write(obj.selectedForCheckout)
      ..writeByte(4)
      ..write(obj.totalItems)
      ..writeByte(5)
      ..write(obj.subTotal)
      ..writeByte(6)
      ..write(obj.totalDiscount)
      ..writeByte(7)
      ..write(obj.grandTotal)
      ..writeByte(8)
      ..write(obj.appliedCouponCode)
      ..writeByte(9)
      ..write(obj.items);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
