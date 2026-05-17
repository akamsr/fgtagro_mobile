import 'package:hive_ce/hive.dart';

part 'support.g.dart';

@HiveType(typeId: 35)
class SupportConversationModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String userId;
  @HiveField(2)
  final String? orderRef;
  @HiveField(3)
  final String status; // open, closed
  @HiveField(4)
  final int unreadCount;
  @HiveField(5)
  final DateTime? escalatedAt;
  @HiveField(6)
  final DateTime createdAt;

  SupportConversationModel({
    required this.id,
    required this.userId,
    this.orderRef,
    required this.status,
    this.unreadCount = 0,
    this.escalatedAt,
    required this.createdAt,
  });

  factory SupportConversationModel.fromJson(Map<String, dynamic> json) {
    return SupportConversationModel(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      orderRef: json['order_ref']?.toString(),
      status: json['status'] ?? 'open',
      unreadCount: json['unread_count'] ?? 0,
      escalatedAt: json['escalated_at'] != null ? DateTime.tryParse(json['escalated_at']) : null,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'order_ref': orderRef,
      'status': status,
      'unread_count': unreadCount,
      'escalated_at': escalatedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}

@HiveType(typeId: 36)
class SupportMessageModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String conversationId;
  @HiveField(2)
  final String senderRole; // user, bot, agent
  @HiveField(3)
  final String content;
  @HiveField(4)
  final DateTime createdAt;

  SupportMessageModel({
    required this.id,
    required this.conversationId,
    required this.senderRole,
    required this.content,
    required this.createdAt,
  });

  factory SupportMessageModel.fromJson(Map<String, dynamic> json) {
    return SupportMessageModel(
      id: json['id']?.toString() ?? '',
      conversationId: json['conversation_id']?.toString() ?? '',
      senderRole: json['sender_role'] ?? 'user',
      content: json['content'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversation_id': conversationId,
      'sender_role': senderRole,
      'content': content,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
