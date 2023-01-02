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

  Future<void> fetchUserData() async{
    userModel = await userRepository.fetchUserData();
    notifyListeners();
  }
}