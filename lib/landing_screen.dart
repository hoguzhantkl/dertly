import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_service.dart';
import 'home_screen.dart';
import 'signin_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AuthService authService = Provider.of<AuthService>(context);
    return StreamBuilder(
      stream: authService.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const HomeScreen(title: 'Dertly App');
        }
        return const SignInScreen();
      },
    );
  }
}