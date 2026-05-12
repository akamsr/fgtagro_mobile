import 'dart:convert';
import 'package:fgtagro_mobile/env/url.dart';
import 'package:fgtagro_mobile/models/device_info.dart';
import 'package:fgtagro_mobile/utils/language/language.dart';
import 'package:fgtagro_mobile/utils/network/network.dart';
import 'package:dio/dio.dart';
import 'package:fgtagro_mobile/config/network/api_client.dart';
import 'package:fgtagro_mobile/utils/storage/locator.storage.dart';

class CrashReportService {
  Future<void> reportError(CustomDevInfo report) async {
    final response = await locator<ApiClient>().dio.post(
      '${apiUrl}error/add?lang=${LanguageService.current}',
      options: Options(headers: await NetworkUtils.headers()),
      data: report.toJson(),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
    } else {
      final body = response.data is String ? jsonDecode(response.data) : response.data;
      throw Exception(body["message"]);
    }
  }
}
