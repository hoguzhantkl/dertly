import 'package:dertly/services/auth_service.dart';
import 'package:dertly/services/user_service.dart';

import '../locator.dart';
import '../models/user_model.dart';

class UserRepository{
  UserService userService = locator<UserService>();
  AuthService authService = locator<AuthService>();

  Future fetchUserData() async{
    final user = authService.getCurrentUser();
    var userData = await userService.getUserData(user.uid);
    if (userData == null) {
      return null;
    } else{
      return UserModel.fromMap(userData);
    }
  }
}