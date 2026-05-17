// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seller.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SellerProfileModelAdapter extends TypeAdapter<SellerProfileModel> {
  @override
  final typeId = 17;

  @override
  SellerProfileModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SellerProfileModel(
      id: fields[0] as String,
      slug: fields[1] as String,
      sellerType: fields[2] as String,
      businessName: fields[3] as String,
      status: fields[4] as String,
      trustLevel: fields[5] as String,
      averageRating: (fields[6] as num).toDouble(),
      totalReviews: (fields[7] as num).toInt(),
      totalSales: (fields[8] as num).toInt(),
      rccmNumber: fields[9] as String?,
      taxId: fields[10] as String?,
      mobileMoneyProvider: fields[11] as String?,
      mobileMoneyPhone: fields[12] as String?,
      bankName: fields[13] as String?,
      payoutFrequency: fields[14] as String,
      storefrontPhotoUrl: fields[15] as String?,
      rejectionReason: fields[16] as String?,
      createdAt: fields[17] as String,
      userId: fields[18] as String?,
      kycDocuments: (fields[19] as List?)?.cast<String>(),
      payoutDestinations: (fields[20] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, SellerProfileModel obj) {
    writer
      ..writeByte(21)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.slug)
      ..writeByte(2)
      ..write(obj.sellerType)
      ..writeByte(3)
      ..write(obj.businessName)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.trustLevel)
      ..writeByte(6)
      ..write(obj.averageRating)
      ..writeByte(7)
      ..write(obj.totalReviews)
      ..writeByte(8)
      ..write(obj.totalSales)
      ..writeByte(9)
      ..write(obj.rccmNumber)
      ..writeByte(10)
      ..write(obj.taxId)
      ..writeByte(11)
      ..write(obj.mobileMoneyProvider)
      ..writeByte(12)
      ..write(obj.mobileMoneyPhone)
      ..writeByte(13)
      ..write(obj.bankName)
      ..writeByte(14)
      ..write(obj.payoutFrequency)
      ..writeByte(15)
      ..write(obj.storefrontPhotoUrl)
      ..writeByte(16)
      ..write(obj.rejectionReason)
      ..writeByte(17)
      ..write(obj.createdAt)
      ..writeByte(18)
      ..write(obj.userId)
      ..writeByte(19)
      ..write(obj.kycDocuments)
      ..writeByte(20)
      ..write(obj.payoutDestinations);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SellerProfileModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StoreModelAdapter extends TypeAdapter<StoreModel> {
  @override
  final typeId = 18;

  @override
  StoreModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StoreModel(
      id: fields[0] as String,
      slug: fields[1] as String,
      code: fields[2] as String,
      name: fields[3] as String,
      city: fields[4] as String,
      district: fields[5] as String?,
      address: fields[6] as String,
      gpsLatitude: (fields[7] as num).toDouble(),
      gpsLongitude: (fields[8] as num).toDouble(),
      phone: fields[9] as String,
      email: fields[10] as String?,
      managerName: fields[11] as String?,
      status: fields[12] as String,
      storefrontPhotoUrl: fields[13] as String?,
      hasColdStorage: fields[14] as bool,
      hasDryWarehouse: fields[15] as bool,
      productsCount: (fields[16] as num).toInt(),
      createdAt: fields[17] as String,
      sellerId: fields[18] as String?,
      surfaceSqm: (fields[19] as num?)?.toDouble(),
      storageCapacityTons: (fields[20] as num?)?.toDouble(),
      storageCapacityPallets: (fields[21] as num?)?.toDouble(),
      hasLivestockArea: fields[22] == null ? false : fields[22] as bool,
      hasHeavyMachineryArea: fields[23] == null ? false : fields[23] as bool,
      hasLoadingDock: fields[24] == null ? false : fields[24] as bool,
      hasForklift: fields[25] == null ? false : fields[25] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, StoreModel obj) {
    writer
      ..writeByte(26)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.slug)
      ..writeByte(2)
      ..write(obj.code)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.city)
      ..writeByte(5)
      ..write(obj.district)
      ..writeByte(6)
      ..write(obj.address)
      ..writeByte(7)
      ..write(obj.gpsLatitude)
      ..writeByte(8)
      ..write(obj.gpsLongitude)
      ..writeByte(9)
      ..write(obj.phone)
      ..writeByte(10)
      ..write(obj.email)
      ..writeByte(11)
      ..write(obj.managerName)
      ..writeByte(12)
      ..write(obj.status)
      ..writeByte(13)
      ..write(obj.storefrontPhotoUrl)
      ..writeByte(14)
      ..write(obj.hasColdStorage)
      ..writeByte(15)
      ..write(obj.hasDryWarehouse)
      ..writeByte(16)
      ..write(obj.productsCount)
      ..writeByte(17)
      ..write(obj.createdAt)
      ..writeByte(18)
      ..write(obj.sellerId)
      ..writeByte(19)
      ..write(obj.surfaceSqm)
      ..writeByte(20)
      ..write(obj.storageCapacityTons)
      ..writeByte(21)
      ..write(obj.storageCapacityPallets)
      ..writeByte(22)
      ..write(obj.hasLivestockArea)
      ..writeByte(23)
      ..write(obj.hasHeavyMachineryArea)
      ..writeByte(24)
      ..write(obj.hasLoadingDock)
      ..writeByte(25)
      ..write(obj.hasForklift);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoreModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
