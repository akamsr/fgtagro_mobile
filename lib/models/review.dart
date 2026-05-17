import 'package:hive_ce/hive.dart';

part 'review.g.dart';

@HiveType(typeId: 33)
class ReviewModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String orderId;
  @HiveField(2)
  final String buyerId;
  @HiveField(3)
  final String sellerId;
  @HiveField(4)
  final String? productId;
  @HiveField(5)
  final double rating;
  @HiveField(6)
  final double? productQualityRating;
  @HiveField(7)
  final double? sellerCommunicationRating;
  @HiveField(8)
  final double? deliverySpeedRating;
  @HiveField(9)
  final String? comment;
  @HiveField(10)
  final List<String> photos;
  @HiveField(11)
  final String? sellerComment;
  @HiveField(12)
  final String moderationStatus; // pending, approved, hidden
  @HiveField(13)
  final DateTime createdAt;

  ReviewModel({
    required this.id,
    required this.orderId,
    required this.buyerId,
    required this.sellerId,
    this.productId,
    required this.rating,
    this.productQualityRating,
    this.sellerCommunicationRating,
    this.deliverySpeedRating,
    this.comment,
    this.photos = const [],
    this.sellerComment,
    this.moderationStatus = 'approved',
    required this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id']?.toString() ?? '',
      orderId: json['order_id']?.toString() ?? '',
      buyerId: json['buyer_id']?.toString() ?? '',
      sellerId: json['seller_id']?.toString() ?? '',
      productId: json['product_id']?.toString(),
      rating: (json['rating'] ?? 0.0).toDouble(),
      productQualityRating: json['product_quality_rating'] != null ? (json['product_quality_rating'] as num).toDouble() : null,
      sellerCommunicationRating: json['seller_communication_rating'] != null ? (json['seller_communication_rating'] as num).toDouble() : null,
      deliverySpeedRating: json['delivery_speed_rating'] != null ? (json['delivery_speed_rating'] as num).toDouble() : null,
      comment: json['comment'],
      photos: json['photos'] != null ? List<String>.from(json['photos']) : [],
      sellerComment: json['seller_comment'],
      moderationStatus: json['moderation_status'] ?? 'approved',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'buyer_id': buyerId,
      'seller_id': sellerId,
      'product_id': productId,
      'rating': rating,
      'product_quality_rating': productQualityRating,
      'seller_communication_rating': sellerCommunicationRating,
      'delivery_speed_rating': deliverySpeedRating,
      'comment': comment,
      'photos': photos,
      'seller_comment': sellerComment,
      'moderation_status': moderationStatus,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
