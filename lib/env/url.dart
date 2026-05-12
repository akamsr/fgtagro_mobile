import 'package:fgtagro_mobile/env/app_config.dart';

/// Returns the active API base URL for the current flavor.
/// Set via AppConfig.init() in main_dev.dart / main_prod.dart.
String get apiUrl => AppConfig.apiBaseUrl.endsWith('/') ? AppConfig.apiBaseUrl : '${AppConfig.apiBaseUrl}/';
