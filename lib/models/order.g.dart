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
      slug: fields[21] as String?,
      buyerId: fields[22] as String?,
      subtotalAmount: fields[23] == null ? 0.0 : (fields[23] as num).toDouble(),
      deliveryFee: fields[24] == null ? 0.0 : (fields[24] as num).toDouble(),
      discountAmount: fields[25] == null ? 0.0 : (fields[25] as num).toDouble(),
      taxAmount: fields[26] == null ? 0.0 : (fields[26] as num).toDouble(),
      fulfillmentType: fields[27] as String?,
      pickupDeadline: fields[28] as DateTime?,
      driverId: fields[29] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, OrderModel obj) {
    writer
      ..writeByte(30)
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
      ..write(obj.paymentStatus)
      ..writeByte(21)
      ..write(obj.slug)
      ..writeByte(22)
      ..write(obj.buyerId)
      ..writeByte(23)
      ..write(obj.subtotalAmount)
      ..writeByte(24)
      ..write(obj.deliveryFee)
      ..writeByte(25)
      ..write(obj.discountAmount)
      ..writeByte(26)
      ..write(obj.taxAmount)
      ..writeByte(27)
      ..write(obj.fulfillmentType)
      ..writeByte(28)
      ..write(obj.pickupDeadline)
      ..writeByte(29)
      ..write(obj.driverId);
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
        return OrderStatus.paymentPending;
      case 1:
        return OrderStatus.paymentConfirmed;
      case 2:
        return OrderStatus.paymentFailed;
      case 3:
        return OrderStatus.pending;
      case 4:
        return OrderStatus.preparing;
      case 5:
        return OrderStatus.driverAssigned;
      case 6:
        return OrderStatus.pickedUp;
      case 7:
        return OrderStatus.outForDelivery;
      case 8:
        return OrderStatus.shipped;
      case 9:
        return OrderStatus.readyForPickup;
      case 10:
        return OrderStatus.delivered;
      case 11:
        return OrderStatus.completed;
      case 12:
        return OrderStatus.cancelledByBuyer;
      case 13:
        return OrderStatus.cancelledAuto;
      case 14:
        return OrderStatus.cancelledByAdmin;
      case 15:
        return OrderStatus.cancelled;
      case 16:
        return OrderStatus.expired;
      case 17:
        return OrderStatus.deliveryFailed;
      case 18:
        return OrderStatus.pickupExpired;
      case 19:
        return OrderStatus.refundRequested;
      case 20:
        return OrderStatus.refunded;
      case 21:
        return OrderStatus.refundRejected;
      default:
        return OrderStatus.paymentPending;
    }
  }

  @override
  void write(BinaryWriter writer, OrderStatus obj) {
    switch (obj) {
      case OrderStatus.paymentPending:
        writer.writeByte(0);
      case OrderStatus.paymentConfirmed:
        writer.writeByte(1);
      case OrderStatus.paymentFailed:
        writer.writeByte(2);
      case OrderStatus.pending:
        writer.writeByte(3);
      case OrderStatus.preparing:
        writer.writeByte(4);
      case OrderStatus.driverAssigned:
        writer.writeByte(5);
      case OrderStatus.pickedUp:
        writer.writeByte(6);
      case OrderStatus.outForDelivery:
        writer.writeByte(7);
      case OrderStatus.shipped:
        writer.writeByte(8);
      case OrderStatus.readyForPickup:
        writer.writeByte(9);
      case OrderStatus.delivered:
        writer.writeByte(10);
      case OrderStatus.completed:
        writer.writeByte(11);
      case OrderStatus.cancelledByBuyer:
        writer.writeByte(12);
      case OrderStatus.cancelledAuto:
        writer.writeByte(13);
      case OrderStatus.cancelledByAdmin:
        writer.writeByte(14);
      case OrderStatus.cancelled:
        writer.writeByte(15);
      case OrderStatus.expired:
        writer.writeByte(16);
      case OrderStatus.deliveryFailed:
        writer.writeByte(17);
      case OrderStatus.pickupExpired:
        writer.writeByte(18);
      case OrderStatus.refundRequested:
        writer.writeByte(19);
      case OrderStatus.refunded:
        writer.writeByte(20);
      case OrderStatus.refundRejected:
        writer.writeByte(21);
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
