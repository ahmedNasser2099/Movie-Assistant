import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_assistant/auth/auth_service.dart';
import 'package:movie_assistant/auth/google_signin_service.dart';
import 'package:movie_assistant/widgets/custom_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final AuthService _authService = AuthService();
  final PageController _pageController = PageController();

  void _nextPage() {
    if (_pageController.page != 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  void _skipToLastPage() {
    _pageController.animateToPage(
      3,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  Future<void> _loginAsGuest() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      // Handle error if anonymous login fails
      print('Anonymous login failed: $e');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            children: <Widget>[
              _buildPage(
                title: 'Welcome to Movie Assistant',
                content: 'Discover new movies and recommendations.',
                image: 'assets/onboarding3.jpg',
              ),
              _buildPage(
                title: 'Explore Categories',
                content: 'Browse movies by top rated, trending, and more.',
                image: 'assets/onboarding4.jpg',
              ),
              _buildPage(
                title: 'Get Personalized Recommendations',
                content: 'Receive movie suggestions based on your taste.',
                image: 'assets/onboarding3.jpg',
              ),
              _buildPage(
                title: 'Start Your Journey',
                content: 'Sign up or log in to begin exploring.',
                image: 'assets/onboarding4.jpg',
                isLastPage: true,
                context: context,
              ),
            ],
          ),
          Positioned(
            top: 40,
            right: 20,
            child: TextButton(
              onPressed: _skipToLastPage,
              child: const Text(
                'Skip',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: _nextPage,
              child: const Icon(Icons.arrow_forward),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage({
    required String title,
    required String content,
    required String image,
    bool isLastPage = false,
    BuildContext? context,
  }) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(image),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken),
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: Colors.black.withOpacity(0),
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/icon.png', height: 100),
            const SizedBox(height: 20),
            const Text(
              'MOVIE ASSISTANT',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 60),
            Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Text(
                content,
                style: const TextStyle(fontSize: 16, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
            if (isLastPage) ...[
              CustomButton(
                text: 'Login',
                icon: Icons.login,
                onPressed: () {
                  Navigator.pushReplacementNamed(context!, '/login');
                },
              ),
              const SizedBox(height: 10),
              CustomButton(
                text: 'Signup',
                icon: Icons.person_add,
                onPressed: () {
                  Navigator.pushReplacementNamed(context!, '/signup');
                },
              ),
              const SizedBox(height: 10),
              CustomButton(
                text: 'Login with Google',
                icon: Icons.login,
                onPressed: () {
                  GoogleSignInService().signInWithGoogle();
                },
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: _loginAsGuest,
                child: const Text(
                  'Continue as Guest',
                  style: TextStyle(fontSize: 16, color: Colors.blue),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
