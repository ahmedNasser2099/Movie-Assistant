import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_service.dart';

class VerifyScreen extends StatefulWidget {
  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  bool _isChecking = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startEmailVerificationCheck();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startEmailVerificationCheck() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
      await FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;
      if (user?.emailVerified ?? false) {
        timer.cancel();
        Navigator.pushReplacementNamed(context, '/preferences');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: Text('Verify Email')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_isChecking)
              CircularProgressIndicator()
            else
              Column(
                children: [
                  Text(
                    'A verification email has been sent to ${user?.email}. Please check your email and click on the verification link.',
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _isChecking = true;
                      });
                      await user?.reload();
                      if (user?.emailVerified == true) {
                        Navigator.pushReplacementNamed(context, '/preferences');
                      } else {
                        setState(() {
                          _isChecking = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Email not verified yet')),
                        );
                      }
                    },
                    child: Text('I have verified'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
