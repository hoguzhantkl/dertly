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

      // TODO: upload the recordedContentAudioUrl to firebase storage then set the contentUrl to the downloadUrl
      debugPrint("uploading the audio in local path contentUrl: ${entryModel.contentUrl}");
      var contentStorageUrl = await storageService.uploadEntryContentAudio(entryModel.entryID, entryModel.contentUrl);
      debugPrint("uploaded audioFile contentStorageUrl: $contentStorageUrl");
      entryModel.contentUrl = contentStorageUrl;

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

  Future listenEntryContentAudio(String? audioStorageUrl) async {
    if (audioStorageUrl == null || audioStorageUrl.isEmpty){
      debugPrint("audioStorageUrl is empty");
      return;
    }

    try {
      debugPrint("playing audio from storageUrl: $audioStorageUrl");
      var downloadUrl = await storageService.getDownloadUrl(audioStorageUrl)
          .catchError((onError){
            debugPrint("error getting downloadUrl: $onError");
          });
      await audioService.player.setSource(UrlSource(downloadUrl));
      await audioService.player.resume();
    }catch(e){
      debugPrint("error playing audio from storageUrl: $audioStorageUrl, error: $e");
      return Future.error(Exception(e));
    }

  }
}