import 'package:dertly/repositories/user_repository.dart';
import 'package:dertly/services/auth_service.dart';
import 'package:dertly/services/user_service.dart';

import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async{
  // databases
  final _sharedPreferences = await SharedPreferences.getInstance();

  // repositories
  locator.registerFactory<UserRepository>(() => UserRepository());

  // services
  locator.registerLazySingleton<AuthService>(() => AuthService());
  locator.registerLazySingleton<UserService>(() => UserService());
}