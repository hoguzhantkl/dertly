import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dertly/models/user_model.dart';
import 'package:dertly/services/storage_service.dart';

import '../locator.dart';

class UserService{
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  StorageService storageService = locator<StorageService>();

  Future<bool> checkIfUserDocExists(String uid) async{
    try{
      var userCollectionRef = firestore.collection("users");
      var userDoc = await userCollectionRef.doc(uid).get();

      return userDoc.exists;
    } catch(e)
    {
      return false;
    }
  }

  Future<void> createUserData(UserModel userModel) async{
    try {
      var userCollectionRef = firestore.collection("users");
      await userCollectionRef.doc(userModel.userID).set(userModel.toJson());
    } catch (e) {
      e.toString();
    }
  }

  Future getUserData(String uid) async{
    var userCollectionRef = firestore.collection("users");
    var userDoc = await userCollectionRef.doc(uid).get();

    if (userDoc.exists){
      return userDoc.data();
    }
    else {
      return null;
    }
  }

  Future<String> uploadUserImage(String userID, String imageFilePath) async{
    File imageFile = File(imageFilePath);
    var userImageStorageUrl = await storageService.uploadFile("users/$userID/userImage.${imageFilePath.split('.').last}", imageFile);
    return userImageStorageUrl;
  }

  Future<String> uploadUserAudio(String userID, String audioFilePath) async{
    File audioFile = File(audioFilePath);
    var userAudioStorageUrl = await storageService.uploadFile("users/$userID/usernameAudio.${audioFilePath.split('.').last}", audioFile);
    return userAudioStorageUrl;
  }

  Future<String> fetchUserImage(String imageStorageUrl) async{
    if (imageStorageUrl.isEmpty){
      return "";
    }

    var userImageLocalPath = await storageService.downloadFile(imageStorageUrl);
    return userImageLocalPath;
  }

  // TODO: We can implement listenUsernameAudio
  Future<String> fetchUsernameAudio(String audioStorageUrl) async{
    if (audioStorageUrl.isEmpty){
      return "";
    }

    var userAudioLocalPath = await storageService.downloadFile(audioStorageUrl);
    return userAudioLocalPath;
  }
}