import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:movie_assistant/auth/auth_service.dart';
import 'package:movie_assistant/auth/google_signin_service.dart';
import 'package:movie_assistant/flutter_gen/gen_l10n/app_localizations.dart';
import 'package:movie_assistant/routes.dart';
import 'package:movie_assistant/services/language_service.dart';
import 'package:movie_assistant/services/theme_service.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
   bool _isDarkTheme = false;
   Locale? _locale;
   
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
      if (languageCode != null) {
        _locale = Locale(languageCode);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
        Provider<GoogleSignInService>(
          create: (_) => GoogleSignInService(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Movie Assistant',
        theme: _isDarkTheme ? ThemeData.dark() : ThemeData.light(),
        themeMode: ThemeMode.system,
        onGenerateRoute: AppRoutes.generateRoute,
        initialRoute: AppRoutes.splash,
        locale: _locale,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''), // English
          Locale('ar', ''), // Arabic
          // Add other supported locales here
        ],
      ),
    );
  }
}
