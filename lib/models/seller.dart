import 'package:hive_ce/hive.dart';

part 'seller.g.dart';

@HiveType(typeId: 17)
class SellerProfileModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String slug;
  @HiveField(2)
  final String sellerType;
  @HiveField(3)
  final String businessName;
  @HiveField(4)
  final String status;
  @HiveField(5)
  final String trustLevel;
  @HiveField(6)
  final double averageRating;
  @HiveField(7)
  final int totalReviews;
  @HiveField(8)
  final int totalSales;
  @HiveField(9)
  final String? rccmNumber;
  @HiveField(10)
  final String? taxId;
  @HiveField(11)
  final String? mobileMoneyProvider;
  @HiveField(12)
  final String? mobileMoneyPhone;
  @HiveField(13)
  final String? bankName;
  @HiveField(14)
  final String payoutFrequency;
  @HiveField(15)
  final String? storefrontPhotoUrl;
  @HiveField(16)
  final String? rejectionReason;
  @HiveField(17)
  final String createdAt;

  SellerProfileModel({
    required this.id,
    required this.slug,
    required this.sellerType,
    required this.businessName,
    required this.status,
    required this.trustLevel,
    required this.averageRating,
    required this.totalReviews,
    required this.totalSales,
    this.rccmNumber,
    this.taxId,
    this.mobileMoneyProvider,
    this.mobileMoneyPhone,
    this.bankName,
    required this.payoutFrequency,
    this.storefrontPhotoUrl,
    this.rejectionReason,
    required this.createdAt,
  });

  factory SellerProfileModel.fromJson(Map<String, dynamic> json) {
    return SellerProfileModel(
      id: json['id']?.toString() ?? '',
      slug: json['slug'] ?? '',
      sellerType: json['seller_type'] ?? 'individual',
      businessName: json['business_name'] ?? '',
      status: json['status'] ?? 'pending',
      trustLevel: json['trust_level'] ?? 'bronze',
      averageRating: (json['average_rating'] ?? 0).toDouble(),
      totalReviews: json['total_reviews'] ?? 0,
      totalSales: json['total_sales'] ?? 0,
      rccmNumber: json['rccm_number'],
      taxId: json['tax_id'],
      mobileMoneyProvider: json['mobile_money_provider'],
      mobileMoneyPhone: json['mobile_money_phone'],
      bankName: json['bank_name'],
      payoutFrequency: json['payout_frequency'] ?? 'weekly',
      storefrontPhotoUrl: json['storefront_photo_url'],
      rejectionReason: json['rejection_reason'],
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'slug': slug,
      'seller_type': sellerType,
      'business_name': businessName,
      'status': status,
      'trust_level': trustLevel,
      'average_rating': averageRating,
      'total_reviews': totalReviews,
      'total_sales': totalSales,
      'rccm_number': rccmNumber,
      'tax_id': taxId,
      'mobile_money_provider': mobileMoneyProvider,
      'mobile_money_phone': mobileMoneyPhone,
      'bank_name': bankName,
      'payout_frequency': payoutFrequency,
      'storefront_photo_url': storefrontPhotoUrl,
      'rejection_reason': rejectionReason,
      'created_at': createdAt,
    };
  }

  SellerProfileModel copyWith({
    String? id,
    String? slug,
    String? sellerType,
    String? businessName,
    String? status,
    String? trustLevel,
    double? averageRating,
    int? totalReviews,
    int? totalSales,
    String? rccmNumber,
    String? taxId,
    String? mobileMoneyProvider,
    String? mobileMoneyPhone,
    String? bankName,
    String? payoutFrequency,
    String? storefrontPhotoUrl,
    String? rejectionReason,
    String? createdAt,
  }) {
    return SellerProfileModel(
      id: id ?? this.id,
      slug: slug ?? this.slug,
      sellerType: sellerType ?? this.sellerType,
      businessName: businessName ?? this.businessName,
      status: status ?? this.status,
      trustLevel: trustLevel ?? this.trustLevel,
      averageRating: averageRating ?? this.averageRating,
      totalReviews: totalReviews ?? this.totalReviews,
      totalSales: totalSales ?? this.totalSales,
      rccmNumber: rccmNumber ?? this.rccmNumber,
      taxId: taxId ?? this.taxId,
      mobileMoneyProvider: mobileMoneyProvider ?? this.mobileMoneyProvider,
      mobileMoneyPhone: mobileMoneyPhone ?? this.mobileMoneyPhone,
      bankName: bankName ?? this.bankName,
      payoutFrequency: payoutFrequency ?? this.payoutFrequency,
      storefrontPhotoUrl: storefrontPhotoUrl ?? this.storefrontPhotoUrl,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

@HiveType(typeId: 18)
class StoreModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String slug;
  @HiveField(2)
  final String code;
  @HiveField(3)
  final String name;
  @HiveField(4)
  final String city;
  @HiveField(5)
  final String? district;
  @HiveField(6)
  final String address;
  @HiveField(7)
  final double gpsLatitude;
  @HiveField(8)
  final double gpsLongitude;
  @HiveField(9)
  final String phone;
  @HiveField(10)
  final String? email;
  @HiveField(11)
  final String? managerName;
  @HiveField(12)
  final String status;
  @HiveField(13)
  final String? storefrontPhotoUrl;
  @HiveField(14)
  final bool hasColdStorage;
  @HiveField(15)
  final bool hasDryWarehouse;
  @HiveField(16)
  final int productsCount;
  @HiveField(17)
  final String createdAt;

  StoreModel({
    required this.id,
    required this.slug,
    required this.code,
    required this.name,
    required this.city,
    this.district,
    required this.address,
    required this.gpsLatitude,
    required this.gpsLongitude,
    required this.phone,
    this.email,
    this.managerName,
    required this.status,
    this.storefrontPhotoUrl,
    required this.hasColdStorage,
    required this.hasDryWarehouse,
    required this.productsCount,
    required this.createdAt,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      id: json['id']?.toString() ?? '',
      slug: json['slug'] ?? '',
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      city: json['city'] ?? '',
      district: json['district'],
      address: json['address'] ?? '',
      gpsLatitude: (json['gps_latitude'] ?? 0).toDouble(),
      gpsLongitude: (json['gps_longitude'] ?? 0).toDouble(),
      phone: json['phone'] ?? '',
      email: json['email'],
      managerName: json['manager_name'],
      status: json['status'] ?? 'pending',
      storefrontPhotoUrl: json['storefront_photo_url'],
      hasColdStorage: json['has_cold_storage'] ?? false,
      hasDryWarehouse: json['has_dry_warehouse'] ?? false,
      productsCount: json['_count']?['products'] ?? 0,
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'slug': slug,
      'code': code,
      'name': name,
      'city': city,
      'district': district,
      'address': address,
      'gps_latitude': gpsLatitude,
      'gps_longitude': gpsLongitude,
      'phone': phone,
      'email': email,
      'manager_name': managerName,
      'status': status,
      'storefront_photo_url': storefrontPhotoUrl,
      'has_cold_storage': hasColdStorage,
      'has_dry_warehouse': hasDryWarehouse,
      '_count': {'products': productsCount},
      'created_at': createdAt,
    };
  }

  StoreModel copyWith({
    String? id,
    String? slug,
    String? code,
    String? name,
    String? city,
    String? district,
    String? address,
    double? gpsLatitude,
    double? gpsLongitude,
    String? phone,
    String? email,
    String? managerName,
    String? status,
    String? storefrontPhotoUrl,
    bool? hasColdStorage,
    bool? hasDryWarehouse,
    int? productsCount,
    String? createdAt,
  }) {
    return StoreModel(
      id: id ?? this.id,
      slug: slug ?? this.slug,
      code: code ?? this.code,
      name: name ?? this.name,
      city: city ?? this.city,
      district: district ?? this.district,
      address: address ?? this.address,
      gpsLatitude: gpsLatitude ?? this.gpsLatitude,
      gpsLongitude: gpsLongitude ?? this.gpsLongitude,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      managerName: managerName ?? this.managerName,
      status: status ?? this.status,
      storefrontPhotoUrl: storefrontPhotoUrl ?? this.storefrontPhotoUrl,
      hasColdStorage: hasColdStorage ?? this.hasColdStorage,
      hasDryWarehouse: hasDryWarehouse ?? this.hasDryWarehouse,
      productsCount: productsCount ?? this.productsCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
