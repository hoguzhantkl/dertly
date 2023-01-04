import 'package:dertly/locator.dart';
import 'package:dertly/services/auth_service.dart';
import 'package:dertly/view_models/auth_viewmodel.dart';
import 'package:dertly/view_models/user_viewmodel.dart';
import 'package:dertly/views/createprofile_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stacked_services/stacked_services.dart';

import 'home_view.dart';

import '../core/routes/router.dart' as rtr;

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AuthViewModel authViewModel = Provider.of<AuthViewModel>(context);
    UserViewModel userViewModel = Provider.of<UserViewModel>(context);

    AuthService authService = locator<AuthService>();

    rtr.Router router = locator<rtr.Router>();

    authService.auth.authStateChanges().listen((User? user) async{
      if (user == null) {
        router.navigateSignInScreen();
      }
      else {
        var userData = await userViewModel.fetchUserData();
        if (userData == null) {
          router.navigateCreateProfileScreen();
        }
        else {
          router.navigateHomeScreen();
        }
      }
    });

    return const CircularProgressIndicator();
  }
}