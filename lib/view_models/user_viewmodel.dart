import 'package:dertly/repositories/user_repository.dart';
import 'package:flutter/widgets.dart';

import 'package:dertly/models/user_model.dart';
import 'package:dertly/services/user_service.dart';

import '../locator.dart';

class UserViewModel extends ChangeNotifier{
  UserViewModel({required this.userRepository});

  final UserRepository userRepository;

  UserModel? userModel;

  UserService userService = locator<UserService>();

  Future<dynamic> fetchUserData() async{
    try{
      var userData = await userRepository.fetchUserData();
      if (userData == null){
        return null;
      }
      userModel = userData;
      return userModel;
    }catch(e){
      return Future.error(Exception(e));
    }
  }
}