import 'package:dertly/core/routes/router.dart';
import 'package:dertly/repositories/entry_repository.dart';
import 'package:dertly/repositories/feeds_repository.dart';
import 'package:dertly/repositories/user_repository.dart';
import 'package:dertly/services/audio_service.dart';
import 'package:dertly/services/auth_service.dart';
import 'package:dertly/services/emulator_service.dart';
import 'package:dertly/services/entry_service.dart';
import 'package:dertly/services/feeds_service.dart';
import 'package:dertly/services/storage_service.dart';
import 'package:dertly/services/user_service.dart';

import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked_services/stacked_services.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async{
  // databases
  final _sharedPreferences = await SharedPreferences.getInstance();

  // services
  locator.registerLazySingleton<Router>(() => Router());
  locator.registerLazySingleton<EmulatorService>(() => EmulatorService());
  locator.registerLazySingleton<AuthService>(() => AuthService());
  locator.registerLazySingleton<StorageService>(() => StorageService());
  locator.registerLazySingleton<AudioService>(() => AudioService());

  locator.registerLazySingleton<UserService>(() => UserService());
  locator.registerLazySingleton<EntryService>(() => EntryService());
  locator.registerLazySingleton<FeedsService>(() => FeedsService());

  // repositories
  locator.registerLazySingleton<UserRepository>(() => UserRepository());
  locator.registerLazySingleton<EntryRepository>(() => EntryRepository());
  locator.registerLazySingleton<FeedsRepository>(() => FeedsRepository());

  // third party services (stacked_services)
  locator.registerLazySingleton<NavigationService>(() => NavigationService());
}