import 'dart:ui';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'locale_provider.g.dart';

const _localeKey = 'locale';

@riverpod
class LocaleNotifier extends _$LocaleNotifier {
  @override
  Locale? build() {
    // Load saved locale on startup
    _loadLocale();
    return null; // null means use system locale
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLocale = prefs.getString(_localeKey);
    if (savedLocale != null) {
      state = Locale(savedLocale);
    }
  }

  Future<void> setLocale(Locale? locale) async {
    state = locale;
    final prefs = await SharedPreferences.getInstance();
    if (locale == null) {
      await prefs.remove(_localeKey);
    } else {
      await prefs.setString(_localeKey, locale.languageCode);
    }
  }
}

/// Supported locales
const supportedLocales = [
  Locale('en'),
  Locale('fr'),
];

/// Get locale display name
String getLocaleDisplayName(Locale? locale) {
  if (locale == null) return 'System';
  switch (locale.languageCode) {
    case 'en':
      return 'English';
    case 'fr':
      return 'Français';
    default:
      return locale.languageCode;
  }
}
