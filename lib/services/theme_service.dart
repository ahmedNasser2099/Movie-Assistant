import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  final String _themeKey = 'theme';

  Future<void> setDarkTheme(bool isDarkTheme) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_themeKey, isDarkTheme);
  }

  Future<bool> isDarkTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeKey) ?? false;
  }
}

