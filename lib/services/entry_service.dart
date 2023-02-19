import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dertly/models/answer_model.dart';
import 'package:dertly/services/audio_service.dart';
import 'package:dertly/services/auth_service.dart';
import 'package:dertly/services/storage_service.dart';
import 'package:flutter/material.dart';

import '../locator.dart';
import '../models/entry_model.dart';
import '../models/feeds_model.dart';

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

      debugPrint("uploading the audio in local path contentUrl: ${entryModel.audioUrl}");
      var contentStorageUrl = await storageService.uploadEntryContentAudio(entryModel.entryID, entryModel.audioUrl);
      debugPrint("uploaded audioFile contentStorageUrl: $contentStorageUrl");
      entryModel.audioUrl = contentStorageUrl;

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

  Future fetchUserEntryDocuments(var entryQuery) async{
    QuerySnapshot documentSnapshots = await entryQuery.get();
    return documentSnapshots.docs;
  }
  Future fetchSomeUserEntryDocuments(String userID, DocumentSnapshot? lastVisibleDoc, int limit) async{
    try {
      var entryCollectionRef = firestore.collection("entries");

      if (lastVisibleDoc == null){
        var entryQuery = entryCollectionRef.where("userID", isEqualTo: userID)
            .orderBy("date", descending: true).limit(limit);

        return await fetchUserEntryDocuments(entryQuery);
      }

      debugPrint("userService fetchSomeUserEntryDocuments, userID: $userID, lastVisibleDoc data: ${lastVisibleDoc.data()}");

      // TODO: should we use lastVisibleDoc.data() instead of lastVisibleDoc?
      var entryQuery = entryCollectionRef.where("userID", isEqualTo: userID)
          .orderBy("date").startAfterDocument(lastVisibleDoc).limit(limit);

      return await fetchUserEntryDocuments(entryQuery);

    } catch(e){
      return Future.error(Exception("Error while fetching some main answers, error: $e"));
    }
  }

  Future<dynamic> listenAudio(String? audioStorageUrl, PlayerController playerController, {noOfSamples = 100}) async{
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
      return await storageService.downloadFile(audioStorageUrl!)
        .then((downloadedAudioFileLocalPath) async {
          debugPrint("downloaded audioFileLocalPath: $downloadedAudioFileLocalPath");

          await playerController.preparePlayer(
              path: downloadedAudioFileLocalPath,
              noOfSamples: noOfSamples,
              volume: 1.0
          );

          await playerController.startPlayer(finishMode: FinishMode.pause);

          return downloadedAudioFileLocalPath;
        })
        .catchError((onError) {return null;});

    } on Exception catch(e){
      return Future.error(Exception("error playing audio from storageUrl: $audioStorageUrl, error: $e"));
    }
  }

  Future listenEntryContentAudio(String? audioStorageUrl, PlayerController playerController) async {
    return await listenAudio(audioStorageUrl, playerController, noOfSamples: WaveNoOfSamples.entry);
  }

  Future listenEntryAnswerAudio(String? audioStorageUrl, PlayerController playerController, {noOfSamples}) async {
    return await listenAudio(audioStorageUrl, playerController, noOfSamples: noOfSamples);
  }
}