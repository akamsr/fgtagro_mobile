import 'package:hive_ce/hive.dart';

part 'cache_record.g.dart';

@HiveType(typeId: 50) // Ensure typeId does not conflict with existing models
class CacheRecord extends HiveObject {
  @HiveField(0)
  final String url;

  @HiveField(1)
  final String responseData;

  @HiveField(2)
  final DateTime timestamp;

  @HiveField(3)
  final Map<String, dynamic>? headers;

  CacheRecord({
    required this.url,
    required this.responseData,
    required this.timestamp,
    this.headers,
  });

  /// Checks if the cache record is still valid (within 48 hours)
  bool get isValid {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    return difference.inHours < 48; // 48-hour invalidation policy
  }
}
