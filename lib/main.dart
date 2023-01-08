import 'package:dertly/core/routes/routing_constants.dart';
import 'package:dertly/repositories/user_repository.dart';
import 'package:dertly/services/emulator_service.dart';
import 'package:dertly/view_models/auth_viewmodel.dart';
import 'package:dertly/view_models/createEntry_viewmodel.dart';
import 'package:dertly/view_models/user_viewmodel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:stacked_services/stacked_services.dart';
import 'services/firebase_options.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'locator.dart';

import 'core/routes/router.dart' as router;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await setupLocator();

  if (true) { //const bool.fromEnvironment("USE_FIREBASE_EMU")
    EmulatorService emulatorService = locator<EmulatorService>();
    await emulatorService.configureFirebaseAuth();
    await emulatorService.configureFirebaseStorage();
    emulatorService.configureFirebaseFirestore();
  }

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthViewModel()),
        ChangeNotifierProvider(create: (context) => UserViewModel(userRepository: locator<UserRepository>())),
        ChangeNotifierProvider(create: (context) => CreateEntryViewModel()),
      ],
      child: MaterialApp(
        title: 'Dertly App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: landingRoute,
        navigatorKey: StackedService.navigatorKey,
        onGenerateRoute: locator<router.Router>().onGenerateRoute,
      )
    );
  }
}


