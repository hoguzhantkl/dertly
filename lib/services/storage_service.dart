import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart' as path_provider;

class StorageService{
  final storageRef = FirebaseStorage.instance.ref();

  Future<String> uploadEntryAudio(String location, File audioFile) async{
    if (!audioFile.existsSync())
    {
      debugPrint("audioFile does not exist");
      return "";
    }
    var entryStorageRef = storageRef.child(location);
    var uploadTask = await entryStorageRef.putFile(audioFile);
    return uploadTask.ref.fullPath;
  }

  Future<String> uploadEntryContentAudio(String entryID, String contentLocalUrl) async{
    var audioFile = File(contentLocalUrl);
    var fileExtension = p.extension(contentLocalUrl);
    return uploadEntryAudio("entries/$entryID/content$fileExtension", audioFile);
  }

  Future<String> uploadEntryAnswerAudio(String entryID, String answerID, String contentLocalUrl) async{
    var audioFile = File(contentLocalUrl);
    var fileExtension = p.extension(contentLocalUrl);
    return uploadEntryAudio("entries/$entryID/$answerID$fileExtension", audioFile);
  }

  Future<dynamic> getDownloadUrl(String storageUrl) async{
    var audioFileRef = storageRef.child(storageUrl);
    return await audioFileRef.getDownloadURL();
  }

}