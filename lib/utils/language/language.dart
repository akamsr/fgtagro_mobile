import 'package:fgtagro_mobile/utils/storage/local.storage.dart';
import 'package:fgtagro_mobile/utils/storage/locator.storage.dart';
import 'package:fgtagro_mobile/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class LanguageService {
  final logger = Logger();

  Locale get locale => loadLanguage();
  String get currentLanguage =>
      locator<StorageServices>().prefs.getString(language) ?? 'french';

  Future<void> setLocale(String lang) async {
    await locator<StorageServices>().prefs.setString(language, lang);
  }

  static const String language = 'language';
  static const String english = 'english';
  static const String french = 'french';

  static String get current =>
      locator<StorageServices>().prefs.getString(language) == 'french'
      ? 'fr'
      : WidgetsBinding.instance.window.locale.languageCode.contains('fr')
      ? 'fr'
      : 'en';

  Locale loadLanguage() {
    final String? lang = locator<StorageServices>().prefs.getString(language);
    if (lang == null) {
      final deviceLocale = WidgetsBinding.instance.window.locale;
      final supportedLocales = S.delegate.supportedLocales;
      final supportedLanguageCodes = supportedLocales
          .map((locale) => locale.languageCode)
          .toList();

      final deviceLanguageCode = deviceLocale.languageCode;
      final defaultLanguageCode =
          supportedLanguageCodes.contains(deviceLanguageCode)
          ? deviceLanguageCode
          : supportedLanguageCodes.first;

      return supportedLocales.firstWhere(
        (locale) => locale.languageCode == defaultLanguageCode,
      );
    } else {
      if (lang == english) {
        return S.delegate.supportedLocales
            .where((element) => element.languageCode == 'en')
            .toList()
            .first;
      } else {
        return S.delegate.supportedLocales
            .where((element) => element.languageCode == 'fr')
            .toList()
            .first;
      }
    }
  }
}
