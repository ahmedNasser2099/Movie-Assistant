import 'package:flutter/material.dart';
import 'package:movie_assistant/services/language_service.dart';
import 'package:movie_assistant/services/theme_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkTheme = false;
  String _selectedLanguage = 'English';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() async {
    final isDarkTheme = await ThemeService().isDarkTheme();
    final languageCode = await LanguageService().getLanguage();
    setState(() {
      _isDarkTheme = isDarkTheme;
      _selectedLanguage = languageCode ?? 'English';
    });
  }

  void _changeTheme(bool value) {
    setState(() {
      _isDarkTheme = value;
      ThemeService().setDarkTheme(value);
    });
  }

  void _changeLanguage(String language) {
    setState(() {
      _selectedLanguage = language;
      LanguageService().setLanguage(language);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Dark Theme'),
            trailing: Switch(
              value: _isDarkTheme,
              onChanged: _changeTheme,
            ),
          ),
          ListTile(
            title: const Text('Language'),
            subtitle: Text(_selectedLanguage),
            onTap: () {
              _showLanguageDialog();
            },
          ),
          // Add more settings options here
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Language'),
          content: SingleChildScrollView(
            child: ListBody(
              children: ['English', 'Arabic', 'French', 'German', 'Spanish']
                  .map((language) => RadioListTile(
                        title: Text(language),
                        value: language,
                        groupValue: _selectedLanguage,
                        onChanged: (String? value) {
                          _changeLanguage(value!);
                          Navigator.of(context).pop();
                        },
                      ))
                  .toList(),
            ),
          ),
        );
      },
    );
  }
}
