import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dertly/repositories/answers_repository.dart';
import 'package:dertly/view_models/entry_viewmodel.dart';
import 'package:flutter/material.dart';

import '../locator.dart';
import '../models/answer_model.dart';
import '../models/vote_model.dart';
import '../services/auth_service.dart';
import '../services/vote_service.dart';

class AnswerViewModel extends ChangeNotifier{
  AnswerViewModel({required this.model});

  AuthService authService = locator<AuthService>();
  VoteService voteService = locator<VoteService>();

  AnswersRepository answersRepository = locator<AnswersRepository>();

  final AnswerModel model;

  void init(){
    clear();
  }

  void clear(){
    model.subAnswers = List.of([]);
    model.listedSubAnswerItemCount.value = 0;
    model.lastVisibleDocumentSnapshot = null;
  }

  Future<void> fetchSomeSubAnswers(EntryViewModel entryViewModel, {bool firstFetch = false}) async{
    debugPrint("answerViewModel, mentionedAnswerID: ${model.answerID} fetchSomeSubAnswers has been called");
    try{
      if (model.isMainAnswer())
      {
        var mentionedAnswerID = model.answerID;

        if (entryViewModel.model == null){
          debugPrint("Could not fetched sub answers for mentionedAnswerID: $mentionedAnswerID, model in entryViewModel is null");
          return;
        }

        if (firstFetch){
          init();
        }

        debugPrint("answerViewModel, Fetching some sub answers for main answer with answerID: $mentionedAnswerID, totalSubAnswers: ${model.totalSubAnswers}, listedSubAnswerItemCount: ${model.listedSubAnswerItemCount.value}");
        var limit = (firstFetch) ? model.pageSizeForFirstFetch : model.pageSize;

        final newSubAnswersDocs = await answersRepository.fetchSomeSubAnswerDocuments(entryViewModel.model!.entryID, model.answerID, model.lastVisibleDocumentSnapshot, limit);
        final newSubAnswers = answersRepository.getAnswerModelsFromDocuments(newSubAnswersDocs);
        if (newSubAnswers == null) {
          debugPrint("Could not fetch sub answers list for mentionedAnswerID: $mentionedAnswerID, answersList is null");
          return;
        }

        if (newSubAnswersDocs.length > 0){
          model.lastVisibleDocumentSnapshot = newSubAnswersDocs[newSubAnswersDocs.length - 1];
        }

        debugPrint("Fetched sub answers for mentionedAnswerID: $mentionedAnswerID, subAnswersList: $newSubAnswers");

        model.subAnswers.addAll(newSubAnswers);
        model.listedSubAnswerItemCount.value += newSubAnswers.length;
      }
    }catch(e){
      return Future.error(Exception(e));
    }
  }

  // Methods for giving up/down votes
  Future giveVote(String answerID, VoteType voteType) async{
    var userID = authService.getCurrentUserUID();

    VoteModel voteModel = VoteModel(voteID: "", voteType: voteType, userID: userID,
        referenceID: answerID, referenceType: ReferenceType.answers, date: Timestamp.now());

    await voteService.giveVote(voteModel);
  }

  Future giveUpVote(String answerID) async{
    await giveVote(answerID, VoteType.upVote);
  }

  Future giveDownVote(String answerID) async{
    await giveVote(answerID, VoteType.downVote);
  }

  // Methods for General Answer Operations
  bool canLoadMoreSubAnswers(){
    return model.listedSubAnswerItemCount.value < model.totalSubAnswers;
  }
}