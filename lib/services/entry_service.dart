import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dertly/services/audio_service.dart';
import 'package:dertly/services/auth_service.dart';
import 'package:dertly/services/storage_service.dart';
import 'package:flutter/material.dart';

import '../locator.dart';
import '../models/entry_model.dart';

class EntryService{
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  AuthService authService = locator<AuthService>();
  StorageService storageService = locator<StorageService>();
  AudioService audioService = locator<AudioService>();

  Future<dynamic> createEntry(EntryModel entryModel) async{
    try {
      var entryCollectionRef = firestore.collection("entries");
      DocumentReference entryDocumentRef = entryCollectionRef.doc();
      DocumentSnapshot entryDocumentSnapshot = await entryDocumentRef.get();
      entryModel.entryID = entryDocumentSnapshot.reference.id;

      debugPrint("uploading the audio in local path contentUrl: ${entryModel.contentAudioUrl}");
      var contentStorageUrl = await storageService.uploadEntryContentAudio(entryModel.entryID, entryModel.contentAudioUrl);
      debugPrint("uploaded audioFile contentStorageUrl: $contentStorageUrl");
      entryModel.contentAudioUrl = contentStorageUrl;

      await entryDocumentSnapshot.reference.set(entryModel.toJson());
      return entryModel;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> fetchEntryData(String entryID) async{
    var entryCollectionRef = firestore.collection("entries");
    var entryDocRef = entryCollectionRef.doc(entryID);
    var entryDocSnapshot = await entryDocRef.get();
    if (entryDocSnapshot.exists){
      return entryDocSnapshot.data();
    }
    else{
      return null;
    }
  }

  Future<dynamic> listenEntryAudio(String? audioStorageUrl) async{
    bool validateStorageUrl(){
      if (audioStorageUrl == null || audioStorageUrl.isEmpty) {
        return false;
      }

      const pattern = r"^([\w\/]+)(\.[\w]+)*$";
      return RegExp(pattern).hasMatch(audioStorageUrl);
    }

    if (!validateStorageUrl()){
      return Future.error(Exception("audioStorageUrl is not valid"));
    }

    try {
      debugPrint("playing audio from storageUrl: $audioStorageUrl");
      var downloadUrl = await storageService.getDownloadUrl(audioStorageUrl!);
      if (downloadUrl != null)
      {
        await audioService.player.setSource(UrlSource(downloadUrl));
        await audioService.player.resume();
      }
    } on Exception catch(e){
      return Future.error(Exception("error playing audio from storageUrl: $audioStorageUrl, error: $e"));
    }
  }

  Future listenEntryContentAudio(String? audioStorageUrl) async {
    return await listenEntryAudio(audioStorageUrl);
  }

  // TODO: use this function when user tries to listen to an answer in entry.
  Future listenEntryAnswerAudio(String? audioStorageUrl) async {
    return await listenEntryAudio(audioStorageUrl);
  }
}