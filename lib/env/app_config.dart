class AppConfig {
  AppConfig._();

  static AppFlavor _flavor = AppFlavor.dev;
  static String _apiBaseUrl = '';
  static String _appName = '';

  static void init({
    required AppFlavor flavor,
    required String apiBaseUrl,
    required String appName,
  }) {
    _flavor = flavor;
    _apiBaseUrl = apiBaseUrl;
    _appName = appName;
  }

  static AppFlavor get flavor => _flavor;
  static String get apiBaseUrl => _apiBaseUrl;
  static String get appName => _appName;
  static bool get isDev => _flavor == AppFlavor.dev;
  static bool get isProd => _flavor == AppFlavor.prod;
}

enum AppFlavor { dev, prod }
