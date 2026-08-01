import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../local_storage_services/local_storage_services.dart';

class SettingsService extends GetxService {
  final Rx<ThemeMode> themeMode = ThemeMode.system.obs;
  final Rx<Locale> locale = const Locale('en', 'US').obs;

  /// Maps stored language codes to full locales used by GetX / Material (matches [AppTranslations]).
  static Locale localeFromCode(String code) {
    switch (code) {
      case 'sv':
        return const Locale('sv', 'SE');
      case 'ar':
        return const Locale('ar', 'SA');
      default:
        return const Locale('en', 'US');
    }
  }

  Future<SettingsService> init() async {
    themeMode.value = ThemeMode.system;
    final lang = LocalStorageService().getLanguageCode();
    locale.value = localeFromCode(lang);
    return this;
  }

  void setThemeMode(ThemeMode mode) {
    themeMode.value = mode;
    LocalStorageService().setThemeMode(_encodeThemeMode(mode));
  }

  void toggleTheme() {
    if (themeMode.value == ThemeMode.dark) {
      setThemeMode(ThemeMode.light);
    } else {
      setThemeMode(ThemeMode.dark);
    }
  }

  /// Persists language, updates reactive locale, and refreshes GetX translations + RTL.
  void applyLanguage(String languageCode) {
    locale.value = localeFromCode(languageCode);
    LocalStorageService().setLanguageCode(languageCode);
    Get.updateLocale(locale.value);
  }

  void setLanguage(String languageCode) => applyLanguage(languageCode);

  String _encodeThemeMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      default:
        return 'system';
    }
  }
}
