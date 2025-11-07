import 'package:flutter/material.dart';

import '../data/local/hive_manager.dart';

enum AppTheme { light, dark, system }

enum AppLanguage { en, vi }

class AppState extends ChangeNotifier {
  AppState() {
    _loadSettings();
  }

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
    if (_theme == theme) return;
    _theme = theme;
    notifyListeners();
  }

  void setLanguage(AppLanguage language) {
    if (_language == language) return;
    _language = language;
    notifyListeners();
  }

  Future<void> loadSettings() => _loadSettings();

  Future<void> saveSettings() async {
    final settingsBox = HiveManager.settingsBox;
    await settingsBox.put('theme', _theme.name);
    await settingsBox.put('language', languageCode);
  }

  Future<void> _loadSettings() async {
    final settingsBox = HiveManager.settingsBox;
    final storedTheme = settingsBox.get('theme') as String?;
    final storedLanguage = settingsBox.get('language') as String?;

    if (storedTheme != null) {
      final match = AppTheme.values.where((theme) => theme.name == storedTheme);
      if (match.isNotEmpty) {
        _theme = match.first;
      }
    }

    if (storedLanguage != null) {
      _language = storedLanguage == 'vi' ? AppLanguage.vi : AppLanguage.en;
    }

    notifyListeners();
  }
}
