import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppLang { ml, en }

class LocaleNotifier extends StateNotifier<AppLang> {
  LocaleNotifier() : super(AppLang.ml) {
    _loadSavedLocale();
  }

  static const String _prefKey = 'selected_language';

  Future<void> _loadSavedLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_prefKey);
      if (saved == 'en') {
        state = AppLang.en;
      } else {
        state = AppLang.ml;
      }
    } catch (_) {}
  }

  Future<void> setLanguage(AppLang lang) async {
    state = lang;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefKey, lang == AppLang.en ? 'en' : 'ml');
    } catch (_) {}
  }

  void toggle() {
    setLanguage(state == AppLang.ml ? AppLang.en : AppLang.ml);
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, AppLang>((ref) {
  return LocaleNotifier();
});
