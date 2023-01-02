import 'package:dertly/locator.dart';
import 'package:dertly/services/auth_service.dart';

class AuthRepository{

  AuthService authService = locator<AuthService>();

  Future<void> fetchUserData() async{
    return authService.getUserData();
  }
}