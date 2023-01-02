import 'package:dertly/services/auth_service.dart';
import 'package:dertly/view_models/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home_view.dart';
import 'signin_view.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AuthViewModel authViewModel = Provider.of<AuthViewModel>(context);
    return StreamBuilder(
      stream: authViewModel.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const HomeScreen(title: 'Dertly App');
        }
        return const SignInScreen();
      },
    );
  }
}