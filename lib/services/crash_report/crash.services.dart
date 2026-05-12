import 'dart:convert';
import 'package:fgtagro_mobile/models/device_info.dart';
import 'package:fgtagro_mobile/utils/error/app_error.dart';
import 'package:fgtagro_mobile/utils/error/global_error_handling/models/error_mapping.dart';
import 'package:fgtagro_mobile/utils/log/log.dart';
import 'package:fgtagro_mobile/utils/network/network.dart';
import 'package:dio/dio.dart';
import 'package:fgtagro_mobile/config/network/api_client.dart';
import 'package:fgtagro_mobile/utils/storage/locator.storage.dart';
import 'package:flutter/foundation.dart';

class CrashReportService {
  Future<void> reportError(CustomDevInfo report) async {
    try {
      final response = await locator<ApiClient>().dio.post(
        'error/add',
        options: Options(headers: NetworkUtils.headers()),
        data: report.toJson(),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        // Log silently in debug — do not rethrow and crash the app over a
        // failed crash report submission.
        final body = response.data is String
            ? jsonDecode(response.data)
            : response.data;
        final msg = body?['message'] ?? 'Crash report submission failed';
        DevLog.show(sanitizeErrorMessage(msg.toString()), name: 'CrashReport');
      }
    } on DioException catch (e) {
      // Swallow network errors for crash reporting — a crash-report failure
      // must never cause a secondary crash or surface to the user.
      if (kDebugMode) {
        DevLog.show(
          'CrashReport DioException: ${e.type.name}',
          name: 'CrashReport',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        DevLog.show('CrashReport unexpected error', name: 'CrashReport');
      }
    }
  }
}
