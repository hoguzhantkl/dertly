import 'package:dertly/repositories/user_repository.dart';
import 'package:dertly/view_models/auth_viewmodel.dart';
import 'package:dertly/view_models/user_viewmodel.dart';
import 'package:dertly/views/landing_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/firebase_options.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  setupLocator();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthViewModel()),
        ChangeNotifierProvider(create: (context) => UserViewModel(userRepository: locator<UserRepository>()))
      ],
      child: MaterialApp(
        title: 'Dertly App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const LandingScreen(),
      )
    );
  }
}


