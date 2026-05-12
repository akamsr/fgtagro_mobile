import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:fgtagro_mobile/services/crash_report/crash.services.dart';
import 'package:fgtagro_mobile/utils/storage/locator.storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../../../models/device_info.dart';
import '../../../routes/router.dart';
import 'global_error_handling/global_app_state.dart';
import 'global_error_handling/models/error_mapping.dart';

abstract class ErrorService {
  /// Whether sending informations to crashlytics is enabled or not.
  ///
  /// Defaults to false during development/debug sessions, activates on released apps.
  static const bool enabled = !kDebugMode;

  static void setupCrashlytics() {
    if (!enabled) return;
    FlutterError.onError = (FlutterErrorDetails details) {
      FirebaseCrashlytics.instance.recordFlutterError(details);
    };
    debugPrint("Setup for Crashlytics finished.");
  }

  // used for development only to document when a function is called without debugging
  static void printFunctionCall(String functionName, [bool finished = false]) {
    debugPrint(
      "$functionName ${finished ? 'finished' : 'called'} @ ${DateTime.now()}",
    );
  }

  static bool shouldBeReported(GlobalErrorData errorData) {
    // Some errors override the default filtering.
    if (errorData.reportToServer != null) return errorData.reportToServer!;

    if (errorData.errorType == ErrorType.NoConnection) return false;
    //Add general exceptions here.

    if (errorData.error is FirebaseAuthException) {
      const ignoredLoginErrors = ['user-not-found', 'wrong-password'];
      return !ignoredLoginErrors.contains(
        (errorData.error as FirebaseAuthException).code,
      );
    }

    return true;
  }

  /// Prints the given error & stacktrace and reports it to backend.
  static Future<void> handleError(
    dynamic error,
    StackTrace? stackTrace, [
    BuildContext? context,
    String? reason,
  ]) async {
    final logger = Logger();
    logger.i(
      "---- ErrorService @ ${DateTime.now()} - Reporting to Crashlytics ----",
    );
    logger.e(error?.toString());
    if (stackTrace != null) debugPrintStack(stackTrace: stackTrace);

    if (enabled) {
      await FirebaseCrashlytics.instance.recordError(
        error,
        stackTrace,
        reason: reason,
      );
      debugPrint("Error sent to Crashlytics.");
    }
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    final CustomDevInfo info = CustomDevInfo(
      brand: '',
      model: '',
      baseOS: '',
      screen: locator<AppRouter>().currentUrl + '${context?.toString() ?? ''}',
      error: error.toString(),
    );

    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      info.brand = androidInfo.brand;
      info.model = androidInfo.model;
      info.baseOS = 'Android' + ' ' + androidInfo.version.release;
    }
    if (Platform.isIOS) {
      final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      info.brand = iosInfo.systemName;
      info.model = iosInfo.model;
      info.baseOS = iosInfo.systemName + ' ' + iosInfo.systemVersion;
    }

    unawaited(CrashReportService().reportError(info));
  }

  static Future<void> log(String message) async {
    final logger = Logger();
    logger.e(message);
    if (!enabled) return;
    await FirebaseCrashlytics.instance.log(message);
  }

  static Future<void> setCustomKey(String key, dynamic value) async {
    debugPrint("$key: $value");
    if (!enabled) return;
    await FirebaseCrashlytics.instance.setCustomKey(key, value);
  }

  static Future<void> setUserIdentifier(String? id) async {
    await FirebaseCrashlytics.instance.setUserIdentifier(id ?? 'null');
  }
}
