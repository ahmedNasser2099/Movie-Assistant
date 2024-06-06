import 'package:flutter/material.dart';
import 'package:movie_assistant/auth/login_screen.dart';
import 'package:movie_assistant/auth/signup_screen.dart';
import 'package:movie_assistant/auth/verify_screen.dart';
import 'package:movie_assistant/screens/chat_screen.dart';
import 'package:movie_assistant/screens/home_screen.dart';
import 'package:movie_assistant/screens/onboarding_screen.dart';
import 'package:movie_assistant/screens/preferences_screen.dart';
import 'package:movie_assistant/screens/recommendation_screen.dart';
import 'package:movie_assistant/screens/search_screen.dart';
import 'package:movie_assistant/screens/splash_screen.dart';
import 'package:movie_assistant/screens/watchlist_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String verify = '/verify';
  static const String home = '/home';
  static const String recommendations = '/recommendations';
  static const String watchlist = '/watchlist';
  static const String search = '/search';
  static const String chat = '/chat';
    static const String preferences = '/preferences';


  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) =>  const SplashScreen());
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case login:
        return MaterialPageRoute(builder: (_) =>  LoginScreen());
      case signup:
        return MaterialPageRoute(builder: (_) =>  SignupScreen());
      case verify:
        return MaterialPageRoute(builder: (_) =>  VerifyScreen());
         case preferences:
        return MaterialPageRoute(builder: (_) =>  const PreferencesScreen(preferredGenres: []));
      case home:
        return MaterialPageRoute(
          builder: (_) => HomeScreen(),
          settings: settings,
        );
      case recommendations:
        return MaterialPageRoute(builder: (_) => const RecommendationScreen());
      case watchlist:
        return MaterialPageRoute(builder: (_) => const WatchlistScreen());
      case search:
        return MaterialPageRoute(builder: (_) => const SearchScreen());
      case chat:
        return MaterialPageRoute(builder: (_) => const ChatScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
        
    }
  }
}
