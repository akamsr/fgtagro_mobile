import 'package:hive_ce/hive.dart';

part 'product.g.dart';

@HiveType(typeId: 5)
class ProductCategoryModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String slug;
  @HiveField(3)
  final String? description;

  ProductCategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
  });

  factory ProductCategoryModel.fromJson(Map<String, dynamic> json) {
    return ProductCategoryModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
    };
  }

  ProductCategoryModel copyWith({
    String? id,
    String? name,
    String? slug,
    String? description,
  }) {
    return ProductCategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      description: description ?? this.description,
    );
  }
}

@HiveType(typeId: 6)
class ProductSellerModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String businessName;
  @HiveField(2)
  final String slug;
  @HiveField(3)
  final String status;

  ProductSellerModel({
    required this.id,
    required this.businessName,
    required this.slug,
    required this.status,
  });

  factory ProductSellerModel.fromJson(Map<String, dynamic> json) {
    return ProductSellerModel(
      id: json['id']?.toString() ?? '',
      businessName: json['business_name'] ?? '',
      slug: json['slug'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'business_name': businessName,
      'slug': slug,
      'status': status,
    };
  }

  ProductSellerModel copyWith({
    String? id,
    String? businessName,
    String? slug,
    String? status,
  }) {
    return ProductSellerModel(
      id: id ?? this.id,
      businessName: businessName ?? this.businessName,
      slug: slug ?? this.slug,
      status: status ?? this.status,
    );
  }
}

@HiveType(typeId: 4)
class ProductModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String slug;
  @HiveField(3)
  final String shortDescription;
  @HiveField(4)
  final String description;
  @HiveField(5)
  final double unitPrice;
  @HiveField(6)
  final String unitOfSale;
  @HiveField(7)
  final int stockQuantity;
  @HiveField(8)
  final String status;
  @HiveField(9)
  final bool isFeatured;
  @HiveField(10)
  final bool isOnSale;
  @HiveField(11)
  final List<String> photos;
  @HiveField(12)
  final List<String> keywords;
  @HiveField(13)
  final ProductCategoryModel category;
  @HiveField(14)
  final ProductSellerModel seller;
  @HiveField(15)
  final String? publishedAt;
  @HiveField(16)
  final String createdAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.shortDescription,
    required this.description,
    required this.unitPrice,
    required this.unitOfSale,
    required this.stockQuantity,
    required this.status,
    required this.isFeatured,
    required this.isOnSale,
    required this.photos,
    required this.keywords,
    required this.category,
    required this.seller,
    this.publishedAt,
    required this.createdAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      shortDescription: json['short_description'] ?? '',
      description: json['description'] ?? '',
      unitPrice: double.tryParse(json['unit_price']?.toString() ?? '0') ?? 0.0,
      unitOfSale: json['unit_of_sale'] ?? '',
      stockQuantity: json['stock_quantity'] ?? 0,
      status: json['status'] ?? '',
      isFeatured: json['is_featured'] ?? false,
      isOnSale: json['is_on_sale'] ?? false,
      photos: List<String>.from(json['photos'] ?? []),
      keywords: List<String>.from(json['keywords'] ?? []),
      category: ProductCategoryModel.fromJson(json['category'] ?? {}),
      seller: ProductSellerModel.fromJson(json['seller'] ?? {}),
      publishedAt: json['published_at'],
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'short_description': shortDescription,
      'description': description,
      'unit_price': unitPrice,
      'unit_of_sale': unitOfSale,
      'stock_quantity': stockQuantity,
      'status': status,
      'is_featured': isFeatured,
      'is_on_sale': isOnSale,
      'photos': photos,
      'keywords': keywords,
      'category': category.toJson(),
      'seller': seller.toJson(),
      'published_at': publishedAt,
      'created_at': createdAt,
    };
  }

  ProductModel copyWith({
    String? id,
    String? name,
    String? slug,
    String? shortDescription,
    String? description,
    double? unitPrice,
    String? unitOfSale,
    int? stockQuantity,
    String? status,
    bool? isFeatured,
    bool? isOnSale,
    List<String>? photos,
    List<String>? keywords,
    ProductCategoryModel? category,
    ProductSellerModel? seller,
    String? publishedAt,
    String? createdAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      shortDescription: shortDescription ?? this.shortDescription,
      description: description ?? this.description,
      unitPrice: unitPrice ?? this.unitPrice,
      unitOfSale: unitOfSale ?? this.unitOfSale,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      status: status ?? this.status,
      isFeatured: isFeatured ?? this.isFeatured,
      isOnSale: isOnSale ?? this.isOnSale,
      photos: photos ?? this.photos,
      keywords: keywords ?? this.keywords,
      category: category ?? this.category,
      seller: seller ?? this.seller,
      publishedAt: publishedAt ?? this.publishedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
