import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:fgtagro_mobile/services/crash_report/crash.services.dart';
import 'package:fgtagro_mobile/utils/error/app_error.dart';
import 'package:fgtagro_mobile/utils/storage/locator.storage.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import '../../models/device_info.dart';
import '../../routes/router.dart';

class ReportingService {
  ReportingService._();

  static const bool _enabled = !kDebugMode;
  static final _logger = Logger(printer: PrettyPrinter(methodCount: 0));

  static void init() {
    if (!_enabled) return;
    FlutterError.onError = (d) => FirebaseCrashlytics.instance.recordFlutterFatalError(d);
    PlatformDispatcher.instance.onError = (e, s) {
      FirebaseCrashlytics.instance.recordError(e, s, fatal: true);
      return true;
    };
  }

  static Future<void> report(AppFailure failure) async {
    _log(failure);
    if (!failure.reportable) return;

    if (_enabled) {
      await FirebaseCrashlytics.instance.recordError(
        failure.originalError ?? failure.message,
        failure.stackTrace,
        reason: failure.message,
        information: ['ID: ${failure.id}', 'Type: ${failure.type.name}'],
      );
    }
    await _reportCustom(failure);
  }

  static void _log(AppFailure f) {
    if (kDebugMode) {
      _logger.e('AUDIT [${f.id}] ${f.type.name}: ${f.message}', error: f.originalError, stackTrace: f.stackTrace);
    }
  }

  static Future<void> _reportCustom(AppFailure f) async {
    try {
      final info = CustomDevInfo(
        brand: Platform.isAndroid ? (await DeviceInfoPlugin().androidInfo).brand : 'Apple',
        model: Platform.isAndroid ? (await DeviceInfoPlugin().androidInfo).model : (await DeviceInfoPlugin().iosInfo).model,
        baseOS: Platform.isAndroid ? 'Android ${(await DeviceInfoPlugin().androidInfo).version.release}' : 'iOS ${(await DeviceInfoPlugin().iosInfo).systemVersion}',
        screen: _getRoute(),
        error: '[${f.type.name}] ${f.message} (${f.id})',
      );
      await CrashReportService().reportError(info);
    } catch (_) {}
  }

  static String _getRoute() {
    try {
      return Uri.tryParse(locator<AppRouter>().currentUrl)?.path ?? 'unknown';
    } catch (_) { return 'unknown'; }
  }

  static Future<void> setUser(String? id) async {
    if (_enabled) await FirebaseCrashlytics.instance.setUserIdentifier(id ?? 'anonymous');
  }

  static Future<void> log(String msg) async {
    if (kDebugMode) print('LOG: $msg');
    if (_enabled) await FirebaseCrashlytics.instance.log(msg);
  }
}
