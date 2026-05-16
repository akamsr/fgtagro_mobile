// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderModelAdapter extends TypeAdapter<OrderModel> {
  @override
  final typeId = 11;

  @override
  OrderModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderModel(
      id: fields[0] as String,
      orderNumber: fields[1] as String,
      status: fields[2] as OrderStatus,
      totalAmount: (fields[3] as num).toDouble(),
      createdAt: fields[4] as DateTime,
      items: (fields[5] as List).cast<CartItem>(),
      shippingAddress: fields[6] as String?,
      paymentMethod: fields[7] as String?,
      customerName: fields[8] as String?,
      deliveryMethod: fields[9] == null ? 'HOME_DELIVERY' : fields[9] as String,
      buyerCity: fields[10] as String?,
      buyerNeighborhood: fields[11] as String?,
      driverName: fields[12] as String?,
      driverPhone: fields[13] as String?,
      storeName: fields[14] as String?,
      storeAddress: fields[15] as String?,
      timeline: fields[16] == null
          ? const {}
          : (fields[16] as Map).cast<OrderStatus, DateTime>(),
      cancellationReason: fields[17] as String?,
      payoutAmount: (fields[18] as num?)?.toDouble(),
      payoutDate: fields[19] as DateTime?,
      paymentStatus: fields[20] == null ? 'PAID' : fields[20] as String,
    );
  }

  @override
  void write(BinaryWriter writer, OrderModel obj) {
    writer
      ..writeByte(21)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.orderNumber)
      ..writeByte(2)
      ..write(obj.status)
      ..writeByte(3)
      ..write(obj.totalAmount)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.items)
      ..writeByte(6)
      ..write(obj.shippingAddress)
      ..writeByte(7)
      ..write(obj.paymentMethod)
      ..writeByte(8)
      ..write(obj.customerName)
      ..writeByte(9)
      ..write(obj.deliveryMethod)
      ..writeByte(10)
      ..write(obj.buyerCity)
      ..writeByte(11)
      ..write(obj.buyerNeighborhood)
      ..writeByte(12)
      ..write(obj.driverName)
      ..writeByte(13)
      ..write(obj.driverPhone)
      ..writeByte(14)
      ..write(obj.storeName)
      ..writeByte(15)
      ..write(obj.storeAddress)
      ..writeByte(16)
      ..write(obj.timeline)
      ..writeByte(17)
      ..write(obj.cancellationReason)
      ..writeByte(18)
      ..write(obj.payoutAmount)
      ..writeByte(19)
      ..write(obj.payoutDate)
      ..writeByte(20)
      ..write(obj.paymentStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class OrderStatusAdapter extends TypeAdapter<OrderStatus> {
  @override
  final typeId = 12;

  @override
  OrderStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return OrderStatus.pending;
      case 1:
        return OrderStatus.preparing;
      case 2:
        return OrderStatus.shipped;
      case 3:
        return OrderStatus.delivered;
      case 4:
        return OrderStatus.cancelled;
      case 5:
        return OrderStatus.paymentConfirmed;
      default:
        return OrderStatus.pending;
    }
  }

  @override
  void write(BinaryWriter writer, OrderStatus obj) {
    switch (obj) {
      case OrderStatus.pending:
        writer.writeByte(0);
      case OrderStatus.preparing:
        writer.writeByte(1);
      case OrderStatus.shipped:
        writer.writeByte(2);
      case OrderStatus.delivered:
        writer.writeByte(3);
      case OrderStatus.cancelled:
        writer.writeByte(4);
      case OrderStatus.paymentConfirmed:
        writer.writeByte(5);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
