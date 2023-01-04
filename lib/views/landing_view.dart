import 'package:dertly/view_models/auth_viewmodel.dart';
import 'package:dertly/view_models/user_viewmodel.dart';
import 'package:dertly/views/createprofile_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home_view.dart';
import 'signin_view.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AuthViewModel authViewModel = Provider.of<AuthViewModel>(context);
    UserViewModel userViewModel = Provider.of<UserViewModel>(context);
    return StreamBuilder(
      stream: authViewModel.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.hasData && authViewModel.isSignedIn()) {
          return FutureBuilder(
              future: userViewModel.fetchUserData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData && snapshot.data != null) {
                    return const HomeScreen(title: 'Dertly App');
                  }
                  else {
                    return Navigator(
                      onGenerateRoute: (settings) {
                        return MaterialPageRoute(
                            builder: (context) => const CreateProfileScreen());
                      },
                    );
                  }
                }

                return const CircularProgressIndicator();
              }
          );
        }
        return const SignInScreen();
      },
    );
  }
}