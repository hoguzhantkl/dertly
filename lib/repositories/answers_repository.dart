import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dertly/services/answers_service.dart';
import 'package:flutter/cupertino.dart';

import '../locator.dart';
import '../models/answer_model.dart';

class AnswersRepository{
  AnswersService answersService = locator<AnswersService>();

  List<AnswerModel>? getAnswerModelsFromDocuments(var answersDocuments){
    if (answersDocuments != null){
      List<AnswerModel> answerModels = [];
      for (var answerDocument in answersDocuments){
        var answerData = answerDocument.data();
        answerModels.add(AnswerModel.fromMap(answerData));
      }

      return answerModels;
    }

    return null;
  }

  Future fetchAllAnswers(String entryID) async{
    var answersDocuments = await answersService.fetchAllAnswersDocuments(entryID);
    return getAnswerModelsFromDocuments(answersDocuments);
  }

  Future fetchSomeMainAnswerDocuments(String entryID, DocumentSnapshot? lastVisibleDoc, int limit) async {
    debugPrint("answersRepo - fetchSomeMainAnswers, entryID: $entryID, lastVisibleDoc data: ${lastVisibleDoc?.data()}, limit: $limit");
    var answersDocuments = await answersService.fetchSomeMainAnswersDocuments(entryID, lastVisibleDoc, limit);
    debugPrint("answersRepo - mainAnswersDocuments, answerRepo: $answersDocuments");
    return answersDocuments;
  }

  Future fetchSomeSubAnswerDocuments(String entryID, String mentionedAnswerID, DocumentSnapshot? lastVisibleDoc, int limit) async {
    debugPrint("answersRepo - fetchSomeSubAnswers, entryID: $entryID, mentionedAnswerID: $mentionedAnswerID, lastVisibleDoc data: ${lastVisibleDoc?.data()} limit: $limit");
    var answersDocuments = await answersService.fetchSomeSubAnswersDocuments(entryID, mentionedAnswerID, lastVisibleDoc, limit);
    debugPrint("answersRepo - subAnswersDocuments, mentionedAnswerID: $mentionedAnswerID, answerRepo: $answersDocuments");
    return answersDocuments;
  }
}