import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = const Locale('en'); // اللغة الافتراضية هي الإنجليزية

  Locale get locale => _locale;

  // تغيير اللغة وتخزينها في SharedPreferences
  Future<void> setLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
    _locale = locale;
    notifyListeners(); // إعلام المستمعين بتغيير اللغة
  }

  // استرجاع اللغة من SharedPreferences عند بدء التطبيق
  Future<void> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString('language_code');
    if (languageCode != null) {
      _locale = Locale(languageCode);
    }
    notifyListeners(); // إعلام المستمعين بعد تحميل اللغة
  }
}
