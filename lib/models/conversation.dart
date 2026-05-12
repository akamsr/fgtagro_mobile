import 'package:hive_ce/hive.dart';

part 'conversation.g.dart';

@HiveType(typeId: 13)
class ConversationModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String? name;
  @HiveField(2)
  final String? lastMessage;
  @HiveField(3)
  final String? lastMessageTime;
  @HiveField(4)
  final int? unreadCount;
  @HiveField(5)
  final bool? isOnline;
  @HiveField(6)
  final String? avatar;

  ConversationModel({
    required this.id,
    this.name,
    this.lastMessage,
    this.lastMessageTime,
    this.unreadCount,
    this.isOnline,
    this.avatar,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id']?.toString() ?? '',
      name: json['name'],
      lastMessage: json['lastMessage'],
      lastMessageTime: json['lastMessageTime'],
      unreadCount: json['unreadCount']?.toInt(),
      isOnline: json['isOnline'],
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime,
      'unreadCount': unreadCount,
      'isOnline': isOnline,
      'avatar': avatar,
    };
  }

  ConversationModel copyWith({
    String? id,
    String? name,
    String? lastMessage,
    String? lastMessageTime,
    int? unreadCount,
    bool? isOnline,
    String? avatar,
  }) {
    return ConversationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      unreadCount: unreadCount ?? this.unreadCount,
      isOnline: isOnline ?? this.isOnline,
      avatar: avatar ?? this.avatar,
    );
  }
}
