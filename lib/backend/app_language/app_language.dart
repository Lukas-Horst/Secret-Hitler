// author: Lukas Horst

import 'dart:ui';

import 'package:secret_hitler/backend/database/hive_database.dart';

import 'locales.dart';

class AppLanguage {
  static late String _currentLanguage;

  static Future<void> init() async {
    String? language = await HiveDatabase.getValue('language');
    if (language != null) {
      _currentLanguage = language;
    } else {
      _currentLanguage = window.locale.languageCode;
      if (!['de', 'en'].contains(_currentLanguage)) {
        // English is the standard language if the device language isn't german
        _currentLanguage = 'en';
      }
      await HiveDatabase.insertData('language', _currentLanguage);
    }
  }

  // Method to set the app language and save it in the database
  static Future<void> setCurrentLanguage(String language) async {
    _currentLanguage = language;
    await HiveDatabase.insertData('language', _currentLanguage);
  }

  // Method to get the data from the current language
  static Map<String, dynamic> getLanguageData() {
    if (_currentLanguage == 'de') {
      return LocaleData.DE;
    } else {
      return LocaleData.EN;
    }
  }
}