import 'package:dertly/models/user_model.dart';

import '../locator.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';

class CreateProfileViewModel{
  AuthService authService = locator<AuthService>();
  UserService userService = locator<UserService>();

  Future<void> createUserProfile() async{
    var userID = await authService.getCurrentUserUID();
    var testUserName = "User Name";
    UserModel userModel = UserModel(userID: userID, userName: testUserName);
    await userService.createUserData(userModel);
  }
}