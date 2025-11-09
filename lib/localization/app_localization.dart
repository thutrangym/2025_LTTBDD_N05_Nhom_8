import 'package:flutter/material.dart';

class AppLocalizations {
  static const supportedLocales = [Locale('en', 'US'), Locale('vi', 'VN')];

  static const path = 'assets/i18n';

  static Future<void> initialize() async {
    // This will be handled by easy_localization
  }
}
