import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Holds the app [Locale] and persists it so restarts keep the choice.
class LocaleProvider extends ChangeNotifier {
  static const String _prefsKey = 'app_locale';

  Locale _locale = const Locale('ar');

  Locale get locale => _locale;

  LocaleProvider() {
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_prefsKey);
    if (code == 'ar') {
      _locale = const Locale('ar');
      notifyListeners();
    } else if (code == 'en') {
      _locale = const Locale('en');
      notifyListeners();
    }
  }

  Future<void> setLocale(Locale value) async {
    if (_locale == value) return;
    _locale = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, value.languageCode);
  }

  /// Switches between Arabic and English.
  Future<void> toggleLocale() async {
    final next = _locale.languageCode == 'ar'
        ? const Locale('en')
        : const Locale('ar');
    await setLocale(next);
  }
}
