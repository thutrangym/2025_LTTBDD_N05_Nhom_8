import 'package:flutter/material.dart';

enum AppTheme { light, dark, system }

enum AppLanguage { en, vi }

class AppState extends ChangeNotifier {
  AppTheme _theme = AppTheme.system;
  AppLanguage _language = AppLanguage.en;

  AppTheme get theme => _theme;
  AppLanguage get language => _language;

  ThemeMode get themeMode {
    switch (_theme) {
      case AppTheme.light:
        return ThemeMode.light;
      case AppTheme.dark:
        return ThemeMode.dark;
      case AppTheme.system:
        return ThemeMode.system;
    }
  }

  String get languageCode {
    switch (_language) {
      case AppLanguage.en:
        return 'en';
      case AppLanguage.vi:
        return 'vi';
    }
  }

  void setTheme(AppTheme theme) {
    _theme = theme;
    notifyListeners();
  }

  void setLanguage(AppLanguage language) {
    _language = language;
    notifyListeners();
  }

  void loadSettings() {
    // Load from local storage if needed
    // For now, using defaults
  }

  void saveSettings() {
    // Save to local storage
    // Implementation depends on storage solution
  }
}
