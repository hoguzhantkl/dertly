import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dertly/services/answers_service.dart';

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

  Future fetchSomeMainAnswers(String entryID, int startIndex, int endIndex) async {
    var answersDocuments = await answersService.fetchSomeMainAnswersDocuments(entryID, startIndex, endIndex);
    return getAnswerModelsFromDocuments(answersDocuments);
  }

  Future fetchAllSubAnswers(String entryID, String mentionedAnswerID) async{
    var answersDocuments = await answersService.fetchAllSubAnswersDocuments(entryID, mentionedAnswerID);
    return getAnswerModelsFromDocuments(answersDocuments);
  }

}