import 'package:dertly/services/auth_service.dart';
import 'package:dertly/repositories/auth_repository.dart';

import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async{
  final _sharedPreferences = await SharedPreferences.getInstance();

  // repositories
  locator.registerFactory<AuthRepository>(() => AuthRepository());

  // services
  locator.registerLazySingleton<AuthService>(() => AuthService());
}