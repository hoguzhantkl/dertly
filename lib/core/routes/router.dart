import 'package:dertly/core/routes/routing_constants.dart';
import 'package:dertly/core/routes/undefined_route.dart';
import 'package:dertly/views/entry_view.dart';
import 'package:dertly/views/landing_view.dart';
import 'package:dertly/views/signin_view.dart';
import 'package:dertly/views/signup_view.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../locator.dart';
import '../../views/createprofile_view.dart';
import '../../views/home_view.dart';
import '../../views/profile_view.dart';
import '../../views/starter_view.dart';

class Router {
  final navigator = locator<NavigationService>();

  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case starterRoute:
        return MaterialPageRoute(builder: (_) => const StarterScreen());
      case landingRoute:
        return MaterialPageRoute(builder: (_) => const LandingScreen());
      case signInRoute:
        return MaterialPageRoute(builder: (_) => const SignInScreen());
      case createProfileRoute:
        return MaterialPageRoute(builder: (_) => const CreateProfileScreen());
      case signUpRoute:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case homeRoute:
        return MaterialPageRoute(
            builder: (_) => const HomeScreen(title: 'Dertly'));
      case entryRoute:
        return MaterialPageRoute(builder: (_) => const EntryScreen());
      case profileRoute:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      default:
        return MaterialPageRoute(builder: (_) => const UndefinedRouteView());
    }
  }

  Future navigateTo(String routeName) async {
    navigator.navigateTo(routeName);
  }

  Future replaceWith(String routeName) async {
    navigator.replaceWith(routeName);
  }

  Future navigateLandingScreen() async {
    navigator.clearStackAndShow(landingRoute);
  }

  Future navigateSignInScreen() async {
    navigator.navigateTo(signInRoute);
  }

  Future navigateSignUpScreen() async {
    navigator.navigateTo(signUpRoute);
  }

  Future navigateHomeScreen() async {
    navigator.clearStackAndShow(homeRoute);
  }

  Future navigateCreateProfileScreen() async {
    navigator.replaceWith(createProfileRoute);
  }

  Future navigateEntryScreen() async {
    navigator.navigateTo(entryRoute);
  }

  Future navigateProfileScreen() async {
    navigator.navigateTo(profileRoute);
  }
}
