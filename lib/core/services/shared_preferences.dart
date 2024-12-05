import 'package:shared_preferences/shared_preferences.dart';

class LanguageHelper {
  static const String _key = 'language_code';

  // حفظ اللغة المفضلة
  static Future<void> setLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_key, languageCode);
  }

  // استرجاع اللغة المفضلة
  static Future<String> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key) ??
        'en'; // إذا لم تكن هناك لغة مفضلة، الافتراضي هو الإنجليزية
  }
}
