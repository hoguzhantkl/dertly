import 'dart:io';

import 'package:dertly/models/user_temp_data_model.dart';
import 'package:dertly/repositories/user_repository.dart';
import 'package:flutter/widgets.dart';

import 'package:dertly/models/user_model.dart';
import 'package:dertly/services/user_service.dart';

import '../locator.dart';

class UserViewModel extends ChangeNotifier{
  UserViewModel({required this.userRepository});

  final UserRepository userRepository;

  UserModel? userModel;
  UserTempDataModel userTempDataModel = UserTempDataModel();

  UserService userService = locator<UserService>();

  Future<dynamic> fetchUserData() async{
    try{
      var userData = await userRepository.fetchUserData();
      if (userData == null){
        return null;
      }
      userModel = userData;

      await fetchUserImage().catchError((onError){
        debugPrint("User image could not fetched: $onError");
      });
      await fetchUsernameAudio().catchError((onError){
        debugPrint("Username Audio could not fetched: $onError");
      });

      return userModel;
    }catch(e){
      return Future.error(Exception(e));
    }
  }

  Future<void> fetchUserImage() async{
    try{
      var userImageLocalPath = await userService.fetchUserImage(userModel!.imageUrl);
      userTempDataModel.profileImageFilePath = userImageLocalPath;
    }catch(e){
      return Future.error(Exception(e));
    }
  }

  Future<void> fetchUsernameAudio() async{
    try{
      var userAudioLocalPath = await userService.fetchUsernameAudio(userModel!.audioUrl);
      userTempDataModel.usernameAudioFilePath = userAudioLocalPath;
    }catch(e){
      return Future.error(Exception(e));
    }
  }
}