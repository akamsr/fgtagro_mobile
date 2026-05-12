import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:fgtagro_mobile/utils/storage/local.storage.dart';
import 'package:fgtagro_mobile/utils/storage/locator.storage.dart';

class NetworkUtils {
  static Map<String, String> headers({String? getToken}) {
    final token = locator<StorageServices>().accesToken;
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': token == null ? '' : 'Bearer $token',
      // 'origin': "https://www.buzmeapp.com",
    };
    return headers;
  }

  static Map<String, dynamic> getLocationBody(loc) {
    return {
      "browseMode": locator<StorageServices>().browseMode,
      "userId": locator<StorageServices>().userId ?? 0,
      "distance": locator<StorageServices>().viewDistance,
      "location": {
        "coordinates": {
          "latitude": loc.coordinates.latitude,
          "longitude": loc.coordinates.longitude,
        },
        "region": loc.region,
        "country": loc.country,
        "city_name": locator<StorageServices>().browseCity,
        "postal_code": loc.postal_code,
        "quarter": loc.town,
        "popular_location": true,
        "precision": loc.town,
      },
    };
  }

  static Future<String> getDeviceInfo() async {
    try {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        return "${androidInfo.brand} ${androidInfo.model}, Android ${androidInfo.version.release}";
      } else if (Platform.isIOS) {
        final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        return "${iosInfo.name}, iOS ${iosInfo.systemVersion}";
      }
    } catch (e) {
      return "Unknown Device";
    }
    return "Unknown Device";
  }
}
