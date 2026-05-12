import 'package:fgtagro_mobile/hive_registrar.g.dart';
import 'package:fgtagro_mobile/models/cache/cache_record.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class HiveDbService {
  static const String apiCacheBox = 'api_cache';

  // Singleton instance
  static final HiveDbService _instance = HiveDbService._internal();
  factory HiveDbService() => _instance;
  HiveDbService._internal();

  // Map to store open boxes
  final Map<String, Box<dynamic>> _boxes = {};

  // Initialize Hive
  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapters();
    // Pre-open essential boxes for synchronous access
    await Hive.openBox('settings');
  }

  // Synchronous read for already open boxes
  dynamic readData(String boxName, String key) {
    final box = Hive.box(boxName);
    return box.get(key);
  }


  // Open a box (if not already open)
  Future<Box<dynamic>> _openBox(String boxName) async {
    if (!_boxes.containsKey(boxName)) {
      _boxes[boxName] = await Hive.openBox(boxName);
    }
    return _boxes[boxName]!;
  }

  // Save a model to a specific box
  Future<void> saveModel<T>(String boxName, String key, T model) async {
    try {
      final box = await _openBox(boxName);
      await box.put(key, model);
    } catch (e) {
      // throw Exception('Failed to save model: $e');
    }
  }

  // Retrieve a model from a specific box
  Future<T?> getModel<T>(String boxName, String key) async {
    try {
      final box = await _openBox(boxName);
      return box.get(key) as T?;
    } catch (e) {
      throw Exception('Failed to retrieve model: $e');
    }
  }

  // Delete a model from a specific box
  Future<void> deleteModel(String boxName, String key) async {
    try {
      final box = await _openBox(boxName);
      await box.delete(key);
    } catch (e) {
      throw Exception('Failed to delete model: $e');
    }
  }

  // Clear all models from a specific box
  Future<void> clearBox(String boxName) async {
    try {
      final box = await _openBox(boxName);
      await box.clear();
    } catch (e) {
      throw Exception('Failed to clear box: $e');
    }
  }

  // --- API Cache specific methods ---

  Future<void> saveApiCache(String url, CacheRecord record) async {
    try {
      final box = await _openBox(apiCacheBox);
      await box.put(url, record);
    } catch (e) {
      // Ignore cache save errors silently
    }
  }

  Future<CacheRecord?> getApiCache(String url) async {
    try {
      final box = await _openBox(apiCacheBox);
      return box.get(url) as CacheRecord?;
    } catch (e) {
      return null;
    }
  }

  Future<void> clearExpiredApiCache() async {
    try {
      final box = await _openBox(apiCacheBox);
      final keysToRemove = <dynamic>[];
      
      for (final key in box.keys) {
        final record = box.get(key) as CacheRecord?;
        if (record != null && !record.isValid) {
          keysToRemove.add(key);
        }
      }
      
      if (keysToRemove.isNotEmpty) {
        await box.deleteAll(keysToRemove);
      }
    } catch (e) {
      // Ignore cleanup errors silently
    }
  }

  // Close all open boxes

  Future<void> close() async {
    for (final box in _boxes.values) {
      await box.close();
    }
    _boxes.clear();
  }
}
