import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:fgtagro_mobile/models/location.dart';
import 'package:fgtagro_mobile/utils/theme/colors.dart';
import 'package:fgtagro_mobile/widgets/notification/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:fgtagro_mobile/config/network/api_client.dart';
import 'package:fgtagro_mobile/utils/storage/locator.storage.dart';

class Functionhelper {
  static Future<String> getDeviceType() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.model; // Returns device model like "Pixel 6"
    } else if (Platform.isIOS) {
      final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.model; // Returns device model like "iPhone 13"
    }

    return 'unknown';
  }

  static Future<void> goToDeep(Map<dynamic, dynamic> event) async {
    // if (CustomNavigate.currentContext != null) {
    //   locator<AppRouter>().navigatorKey.currentContext!
    //       .read<BottomNavProvider>()
    //       .onIndexChange(0);
    // }
  }

  Future<Map<String, dynamic>?> uploadImage(
    XFile ImageFile,
    String folder, {
    bool private = false,
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          ImageFile.path,
          filename: ImageFile.path.split('/').last,
        ),
      });

      final response = await locator<ApiClient>().dio.post(
        "https://media.buzmeapp.com/api/public/file/create",
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.data is String ? jsonDecode(response.data) : response.data;
        return body['data'];
      } else {
        showToast("Failed to upload image", bgColor: AppColors.dangerFg);
        return null;
      }
    } catch (e) {
      showToast("Failed to upload image", bgColor: AppColors.dangerFg);
      return null;
    }
  }

  static bool isTokenExpired(String token) {
    if (token.isEmpty) {
      return true;
    }

    try {
      return JwtDecoder.isExpired(token);
    } catch (e) {
      return true;
    }
  }

  Future<Map<String, dynamic>?> uploadFile(
    String filePath,
    String folder, {
    bool private = false,
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          filePath,
          filename: filePath.split('/').last,
        ),
      });

      final response = await locator<ApiClient>().dio.post(
        "https://media.buzmeapp.com/api/public/file/create",
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.data is String ? jsonDecode(response.data) : response.data;
        return body['data'];
      } else {
        showToast("Failed to upload file", bgColor: AppColors.dangerFg);
        return null;
      }
    } catch (e) {
      showToast("Failed to upload file", bgColor: AppColors.dangerFg);
      return null;
    }
  }

  Future<void> downloadFileByUrl(String fileUrl) async {
    try {
      Directory? directory;
      if (Platform.isAndroid) {
        directory = await getExternalStorageDirectory();
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      final String fileName = fileUrl.split('/').last;
      final String savePath = '${directory!.path}/$fileName';

      await locator<ApiClient>().dio.download(fileUrl, savePath);
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
    }
  }

  Future<bool> checkIfInsideCity({
    required List<LocationModel> busiLoca,
    required double userLat,
    required double userLong,
  }) async {
    try {
      final List<Placemark> userPlacemarks = await placemarkFromCoordinates(
        userLat,
        userLong,
      );

      if (userPlacemarks.isNotEmpty) {
        final String? userLocality = userPlacemarks[0].locality;
        if (userLocality != null) {
          for (var location in busiLoca) {
            if (userLocality.trim() == location.town.trim()) {
              return true;
            }
          }
        }
        return false;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<String?> getUserLocality({
    required double userLat,
    required double userLong,
  }) async {
    try {
      final List<Placemark> userPlacemarks = await placemarkFromCoordinates(
        userLat,
        userLong,
      );
      if (userPlacemarks.isNotEmpty) {
        return userPlacemarks[0].locality;
      }
      return '';
    } catch (e) {
      return '';
    }
  }

  bool isForeignLocation(String location) {
    final List<String> parts = location.split(
      RegExp(r'\s*,\s*'),
    ); // Split by ", "

    if (parts.isEmpty) return false; // Ensure it's not empty

    // Further split first part to separate emoji from the country name
    final List<String> firstPartParts = parts[0].trim().split(
      RegExp(r'\s+'),
    ); // Split by spaces

    if (firstPartParts.isEmpty) return false;

    final String firstPart =
        firstPartParts[0]; // Extract the first part (potential flag)

    // Check if firstPart is a country flag emoji (regional indicator symbols)
    if (firstPart.length == 4 &&
        firstPart.runes.every((r) => r >= 0x1F1E6 && r <= 0x1F1FF)) {
      final String countryCode = String.fromCharCodes(
        firstPart.runes.map((r) => r - 0x1F1E6 + 65),
      ); // Convert flag to country code

      return countryCode != "CM"; // Return true if not Cameroon
    }

    return false; // No flag found
  }
}
