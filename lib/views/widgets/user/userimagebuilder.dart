import 'dart:io';

import 'package:dertly/services/user_service.dart';
import 'package:dertly/views/widgets/user/userimage.dart';
import 'package:flutter/material.dart';

import '../../../locator.dart';

class UserImageBuilder extends StatelessWidget{
  const UserImageBuilder({super.key, required this.userID, this.width = 46, this.height = 46, this.borderRadius = 6});

  final String userID;
  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    debugPrint("UserImageBuilder build");
    UserService userService = locator<UserService>();
    return FutureBuilder(
        future: userService.fetchOtherUserImage(userID),
        builder: (context, AsyncSnapshot snapshot){
          File? userImageFile;
          if (snapshot.connectionState == ConnectionState.done){
            try{
              var userImageLocalPath = snapshot.data as String;
              debugPrint("UserImageBuilder fetched from firebase for userID: $userID, userImageLocalPath: $userImageLocalPath");

              userImageFile = File(userImageLocalPath);
              if (!userImageFile.existsSync()){
                userImageFile = null;
              }
            }
            catch(e){
              debugPrint("UserImage could not be get for userID: $userID");
            }

            debugPrint("userImageFile: $userImageFile");
          }

          return UserImage(file: userImageFile, width: width, height: height, borderRadius: borderRadius);
        }
    );

  }

}