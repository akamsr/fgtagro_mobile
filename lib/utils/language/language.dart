import 'package:fgtagro_mobile/utils/storage/hive.storage.dart';
import 'package:fgtagro_mobile/utils/storage/locator.storage.dart';
import 'package:fgtagro_mobile/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class LanguageService {
  final logger = Logger();

  Locale get locale => loadLanguage();
  
  static const String settingsBox = 'settings';
  static const String languageKey = 'language';
  static const String english = 'en';
  static const String french = 'fr';

  Future<void> setLocale(String lang) async {
    await locator<HiveDbService>().saveModel(settingsBox, languageKey, lang);
  }

  static String get current {
    final lang = locator<HiveDbService>().readData(settingsBox, languageKey);
    if (lang != null) return lang;
    return 'en';
  }

  Locale loadLanguage() {
    final String? lang = locator<HiveDbService>().readData(settingsBox, languageKey);
    final supportedLocales = S.delegate.supportedLocales;
    
    if (lang == null) {
      return const Locale('en');
    } else {
      return supportedLocales.firstWhere(
        (locale) => locale.languageCode == lang,
        orElse: () => supportedLocales.first,
      );
    }
  }
}
