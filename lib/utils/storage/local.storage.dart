import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageServices {
  final SharedPreferences prefs;

  StorageServices(this.prefs);

  String get browseMode => prefs.getString('browseMode') ?? 'Local';
  String get signupMethod => prefs.getString('signupMethod') ?? 'password';
  int get viewDistance => prefs.getInt('viewDistance') ?? 80;
  String get browseCity => prefs.getString('browseCity') ?? "Buea";
  String? get accesToken => prefs.getString('token');
  String? get refreshToken => prefs.getString('refreshToken');
  int? get userId => prefs.getInt('userId');
  double get userLatitude => prefs.getDouble("userLatitude") ?? 0.0;
  double get userLongitude => prefs.getDouble("userLongitude") ?? 0.0;

  void saveData(String key, dynamic value) {
    if (value is int) {
      prefs.setInt(key, value);
    } else if (value is String) {
      prefs.setString(key, value);
    } else if (value is bool) {
      prefs.setBool(key, value);
    } else {
      debugPrint("Invalid Type");
    }
  }

  Future<void> saveModel({required String value, required String key}) async {
    await prefs.setString(key, value);
  }

  void clearModel({required String key}) {
    prefs.remove(key);
  }

  dynamic readData(String key) => prefs.get(key);

  Future<bool> deleteData(String key) => prefs.remove(key);
}
