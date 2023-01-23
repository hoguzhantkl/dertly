import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dertly/services/storage_service.dart';
import 'package:flutter/material.dart';

import '../locator.dart';
import '../models/answer_model.dart';

class AnswersService{
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  StorageService storageService = locator<StorageService>();

  Future<dynamic> createAnswer(AnswerModel answerModel) async{
    try {
      var answersCollectionRef = firestore.collection("answers");
      DocumentReference answerDocumentRef = answersCollectionRef.doc();
      DocumentSnapshot answerDocumentSnapshot = await answerDocumentRef.get();
      answerModel.answerID = answerDocumentSnapshot.reference.id;

      debugPrint("uploading the audio in local path answerUrl: ${answerModel.audioUrl}");

      var answerStorageUrl = await storageService.uploadEntryAnswerAudio(answerModel.entryID, answerModel.answerID, answerModel.audioUrl);
      debugPrint("uploaded audioFile answerStorageUrl: $answerStorageUrl");
      answerModel.audioUrl = answerStorageUrl;

      await answerDocumentSnapshot.reference.set(answerModel.toJson());
      return answerModel;
    } catch (e) {
      return Future.error(Exception("Error while creating answer, error: $e"));
    }
  }

  Future fetchAnswersDocuments(var answerQuery) async{
    QuerySnapshot documentSnapshots = await answerQuery.get();
    return documentSnapshots.docs;
  }

  Future fetchAllAnswersDocuments(String entryID) async{
    try {
      var answersCollectionRef = firestore.collection("answers");
      var answersQuery = answersCollectionRef.where("entryID", isEqualTo: entryID);
      return fetchAnswersDocuments(answersQuery);
    } catch (e) {
      return Future.error(Exception("Error while fetching all answers, error: $e"));
    }
  }

  Future fetchAllMainAnswersDocuments(String entryID) async{
    try {
      var answerCollectionRef = firestore.collection("answers");
      var answersQuery = answerCollectionRef.where("entryID", isEqualTo: entryID).where("mentionedAnswerID", isEqualTo: "").where("mentionedUserID", isEqualTo: "");
      return fetchAnswersDocuments(answersQuery);
    } catch(e){
      return Future.error(Exception("Error while fetching all main answers, error: $e"));
    }
  }

  Future fetchAllSubAnswersDocuments(String entryID, String mentionedAnswerID) async{
    try {
      var answerCollectionRef = firestore.collection("answers");
      var answersQuery = answerCollectionRef.where("entryID", isEqualTo: entryID).where("mentionedAnswerID", isEqualTo: mentionedAnswerID);
      return fetchAnswersDocuments(answersQuery);
    } catch(e){
      return Future.error(Exception("Error while fetching all main answers, error: $e"));
    }
  }

}