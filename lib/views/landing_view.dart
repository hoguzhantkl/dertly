import 'package:dertly/locator.dart';
import 'package:dertly/services/audio_service.dart';
import 'package:dertly/services/auth_service.dart';
import 'package:dertly/view_models/auth_viewmodel.dart';
import 'package:dertly/view_models/feeds_viewmodel.dart';
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
    final authService = locator<AuthService>();
    final router = locator<rtr.Router>();

    UserViewModel userViewModel = Provider.of<UserViewModel>(context, listen: false);

    authService.auth.authStateChanges().listen((User? user) async{
      if (user == null) {

        // TODO: write a more proper way to clear all model data (for auth and userViewModels too)
        Provider.of<FeedsViewModel>(context, listen: false).clearModelData();

        router.navigateSignInScreen();
      }
      else {
        await locator<AudioService>().initialize();
        await onUserFound(userViewModel);
      }
    });

    return const CircularProgressIndicator();
  }

  Future onUserFound(UserViewModel userViewModel) async{
    final router = locator<rtr.Router>();

    var counter = 0;
    await Future.doWhile(() async{
      counter++;
      bool success = await userViewModel.fetchUserData()
          .then((userData){
              if (userData == null) {
                router.navigateCreateProfileScreen();
              }
              else {
                router.navigateHomeScreen();
              }
              return true;
            })
          .catchError((error) {
            debugPrint("Error while fetching userData in landing screen: $error");
            return false;
          });

      if (success){
        return false;
      }

      if (counter == 3){
        debugPrint("Failed to fetch user data 3 times");
        router.navigateSignInScreen();
        return false;
      }

      await Future.delayed(const Duration(seconds: 1));

      return true;
    });
  }
}