import 'package:dertly/services/user_service.dart';

import '../locator.dart';
import '../models/user_model.dart';

class UserRepository{
  UserService userService = locator<UserService>();

  Future<UserModel> fetchUserData() async{
    // TODO: create a variable named snapshot from await userService.getUserData();
    // TODO: get those values from the snapshot
    const testUserID = "123456789";
    const testUserName = "Test User";
    return UserModel(userID: testUserID, userName: testUserName);
  }
}