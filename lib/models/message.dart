import 'package:hive_ce/hive.dart';

part 'message.g.dart';

@HiveType(typeId: 15)
enum MessageType {
  @HiveField(0)
  date,
  @HiveField(1)
  product,
  @HiveField(2)
  msg,
}

@HiveType(typeId: 16)
enum MessageRole {
  @HiveField(0)
  seller,
  @HiveField(1)
  buyer,
}

@HiveType(typeId: 14)
class MessageModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final MessageType type;
  @HiveField(2)
  final String? label; // For date type
  @HiveField(3)
  final MessageRole? role;
  @HiveField(4)
  final String? content;
  @HiveField(5)
  final String? time;
  @HiveField(6)
  final bool? isRead;
  @HiveField(7)
  final String? image; // For product or image messages
  @HiveField(8)
  final String? productName; // For product type
  @HiveField(9)
  final String? productPrice; // For product type

  MessageModel({
    required this.id,
    required this.type,
    this.label,
    this.role,
    this.content,
    this.time,
    this.isRead,
    this.image,
    this.productName,
    this.productPrice,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id']?.toString() ?? '',
      type: _parseMessageType(json['type']),
      label: json['label'],
      role: _parseMessageRole(json['role']),
      content: json['content'],
      time: json['time'],
      isRead: json['isRead'],
      image: json['image'],
      productName: json['productName'],
      productPrice: json['productPrice'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'label': label,
      'role': role?.name,
      'content': content,
      'time': time,
      'isRead': isRead,
      'image': image,
      'productName': productName,
      'productPrice': productPrice,
    };
  }

  static MessageType _parseMessageType(dynamic value) {
    switch (value?.toString().toLowerCase()) {
      case 'date':
        return MessageType.date;
      case 'product':
        return MessageType.product;
      case 'msg':
      default:
        return MessageType.msg;
    }
  }

  static MessageRole? _parseMessageRole(dynamic value) {
    switch (value?.toString().toLowerCase()) {
      case 'seller':
        return MessageRole.seller;
      case 'buyer':
        return MessageRole.buyer;
      default:
        return null;
    }
  }

  MessageModel copyWith({
    String? id,
    MessageType? type,
    String? label,
    MessageRole? role,
    String? content,
    String? time,
    bool? isRead,
    String? image,
    String? productName,
    String? productPrice,
  }) {
    return MessageModel(
      id: id ?? this.id,
      type: type ?? this.type,
      label: label ?? this.label,
      role: role ?? this.role,
      content: content ?? this.content,
      time: time ?? this.time,
      isRead: isRead ?? this.isRead,
      image: image ?? this.image,
      productName: productName ?? this.productName,
      productPrice: productPrice ?? this.productPrice,
    );
  }
}
