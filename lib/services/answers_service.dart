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
      var answersQuery = answersCollectionRef.where("entryID", isEqualTo: entryID).orderBy("date");
      return await fetchAnswersDocuments(answersQuery);
    } catch (e) {
      return Future.error(Exception("Error while fetching all answers, error: $e"));
    }
  }

  Future fetchSomeMainAnswersDocuments(String entryID, DocumentSnapshot? lastVisibleDoc, int limit) async{
    try {
      var answerCollectionRef = firestore.collection("answers");

      if (lastVisibleDoc == null){
        var answersQuery = answerCollectionRef.where("entryID", isEqualTo: entryID).where("mentionedAnswerID", isEqualTo: "").where("mentionedUserID", isEqualTo: "")
            .orderBy("date").limit(limit);

        return await fetchAnswersDocuments(answersQuery);
      }

      debugPrint("answerService fetchSomeMainAnswers, entryID: $entryID, lastVisibleDoc data: ${lastVisibleDoc.data()}");

      // TODO: should we use lastVisibleDoc.data() instead of lastVisibleDoc?
      var answersQuery = answerCollectionRef.where("entryID", isEqualTo: entryID).where("mentionedAnswerID", isEqualTo: "").where("mentionedUserID", isEqualTo: "")
          .orderBy("date").startAfterDocument(lastVisibleDoc).limit(limit);

      return await fetchAnswersDocuments(answersQuery);

    } catch(e){
      return Future.error(Exception("Error while fetching some main answers, error: $e"));
    }
  }

  Future fetchAllSubAnswersDocuments(String entryID, String mentionedAnswerID) async{
    try {
      var answerCollectionRef = firestore.collection("answers");
      var answersQuery = answerCollectionRef.where("entryID", isEqualTo: entryID).where("mentionedAnswerID", isEqualTo: mentionedAnswerID)
          .orderBy("date");
      var subAnswersDocuments = await fetchAnswersDocuments(answersQuery);
      return subAnswersDocuments;
    } catch(e){
      return Future.error(Exception("Error while fetching all main answers, error: $e"));
    }
  }

  Future fetchSomeSubAnswersDocuments(String entryID, String mentionedAnswerID, DocumentSnapshot? lastVisibleDoc, int limit) async{
    try {
      var answerCollectionRef = firestore.collection("answers");

      if (lastVisibleDoc == null){
        var answersQuery = answerCollectionRef.where("entryID", isEqualTo: entryID).where("mentionedAnswerID", isEqualTo: mentionedAnswerID)
            .orderBy("date").limit(limit);
        return await fetchAnswersDocuments(answersQuery);
      }

      debugPrint("answerService fetchSomeSubAnswers, mentionedAnswerID: $mentionedAnswerID, lastVisibleDoc data: ${lastVisibleDoc.data()}");

      var answersQuery = answerCollectionRef.where("entryID", isEqualTo: entryID).where("mentionedAnswerID", isEqualTo: mentionedAnswerID)
          .orderBy("date").startAfterDocument(lastVisibleDoc).limit(limit);

      return await fetchAnswersDocuments(answersQuery);

    } catch(e){
      return Future.error(Exception("Error while fetching some sub answers, error: $e"));
    }
  }

}