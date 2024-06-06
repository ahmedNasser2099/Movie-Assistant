import 'package:shared_preferences/shared_preferences.dart';

class LanguageService {
  final String _languageKey = 'language';

  Future<void> setLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_languageKey, languageCode);
  }

  Future<String?> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey);
  }
}
