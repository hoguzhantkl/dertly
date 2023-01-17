import 'package:dertly/core/routes/routing_constants.dart';
import 'package:dertly/core/routes/undefined_route.dart';
import 'package:dertly/views/createEntry_view.dart';
import 'package:dertly/views/landing_view.dart';
import 'package:dertly/views/recorder_view.dart';
import 'package:dertly/views/signin_view.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../locator.dart';
import '../../views/createprofile_view.dart';
import '../../views/home_view.dart';

class Router{
  final navigator = locator<NavigationService>();

  Route<dynamic> onGenerateRoute(RouteSettings settings){
    switch(settings.name){
      case landingRoute:
        return MaterialPageRoute(builder: (_) => const LandingScreen());
      case signInRoute:
        return MaterialPageRoute(builder: (_) => const SignInScreen());
      case createProfileRoute:
        return MaterialPageRoute(builder: (_) => const CreateProfileScreen());
      case homeRoute:
        return MaterialPageRoute(builder: (_) => HomeScreen(title: 'Dertly App'));
      case recorderRoute:
        return MaterialPageRoute(builder: (_) => const RecorderScreen());
      case createEntryRoute:
        return MaterialPageRoute(builder: (_) => const CreateEntryScreen());
      default:
        return MaterialPageRoute(builder: (_) => const UndefinedRouteView());
    }
  }

  Future<dynamic>? navigateTo(String routeName){
    return navigator.navigateTo(routeName);
  }

  Future<dynamic>? replaceWith(String routeName){
    return navigator.replaceWith(routeName);
  }

  Future<dynamic>? navigateSignInScreen(){
    return navigator.replaceWith(signInRoute);
  }

  Future<dynamic>? navigateHomeScreen(){
    return navigator.replaceWith(homeRoute);
  }

  Future<dynamic>? navigateCreateProfileScreen(){
    return navigator.replaceWith(createProfileRoute);
  }
}

