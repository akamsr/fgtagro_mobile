import 'package:hive_ce/hive.dart';

part 'category.g.dart';

@HiveType(typeId: 7)
class CategoryModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String slug;
  @HiveField(3)
  final String? description;
  @HiveField(4)
  final String? icon;
  @HiveField(5)
  final String? parentId;
  @HiveField(6)
  final double commissionRate;
  @HiveField(7)
  final double vatRate;
  @HiveField(8)
  final bool isReturnable;
  @HiveField(9)
  final int maxReturnDays;
  @HiveField(10)
  final bool requiresPhysicalInspection;

  CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.icon,
    this.parentId,
    this.commissionRate = 0.0,
    this.vatRate = 0.0,
    this.isReturnable = true,
    this.maxReturnDays = 30,
    this.requiresPhysicalInspection = false,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'],
      icon: json['icon'],
      parentId: json['parent_id']?.toString(),
      commissionRate: (json['commission_rate'] ?? 0.0).toDouble(),
      vatRate: (json['vat_rate'] ?? 0.0).toDouble(),
      isReturnable: json['is_returnable'] ?? true,
      maxReturnDays: json['max_return_days'] ?? 30,
      requiresPhysicalInspection: json['requires_physical_inspection'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'icon': icon,
      'parent_id': parentId,
      'commission_rate': commissionRate,
      'vat_rate': vatRate,
      'is_returnable': isReturnable,
      'max_return_days': maxReturnDays,
      'requires_physical_inspection': requiresPhysicalInspection,
    };
  }

  CategoryModel copyWith({
    String? id,
    String? name,
    String? slug,
    String? description,
    String? icon,
    String? parentId,
    double? commissionRate,
    double? vatRate,
    bool? isReturnable,
    int? maxReturnDays,
    bool? requiresPhysicalInspection,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      parentId: parentId ?? this.parentId,
      commissionRate: commissionRate ?? this.commissionRate,
      vatRate: vatRate ?? this.vatRate,
      isReturnable: isReturnable ?? this.isReturnable,
      maxReturnDays: maxReturnDays ?? this.maxReturnDays,
      requiresPhysicalInspection: requiresPhysicalInspection ?? this.requiresPhysicalInspection,
    );
  }
}
