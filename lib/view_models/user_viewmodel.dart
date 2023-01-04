import 'package:dertly/repositories/user_repository.dart';
import 'package:flutter/widgets.dart';

import 'package:dertly/models/user_model.dart';
import 'package:dertly/services/user_service.dart';

import '../locator.dart';

class UserViewModel extends ChangeNotifier{
  UserViewModel({required this.userRepository});

  final UserRepository userRepository;

  late UserModel userModel;

  UserService userService = locator<UserService>();

  Future fetchUserData() async{
    try {
      userModel = await userRepository.fetchUserData();
      return userModel;
    } catch (e) {
      return null;
    }
  }
}