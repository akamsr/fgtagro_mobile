import 'package:fgtagro_mobile/utils/language/language.dart';
import 'package:fgtagro_mobile/utils/storage/locator.storage.dart';
import 'package:flutter/material.dart';

class LocaleProvider with ChangeNotifier {
  Locale _locale = locator<LanguageService>().locale;

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (_locale == locale) return;
    _locale = locale;
    
    // Persist choice
    final langString = locale.languageCode == 'en' 
        ? LanguageService.english 
        : LanguageService.french;
    locator<LanguageService>().setLocale(langString);
    
    notifyListeners();
  }

  void clearLocale() {
    _locale = const Locale('en');
    locator<LanguageService>().setLocale(LanguageService.english);
    notifyListeners();
  }
}
