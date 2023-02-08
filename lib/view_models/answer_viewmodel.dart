import 'package:cloud_firestore/cloud_firestore.dart';
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

  final AnswerModel model;

  List<AnswerModel> subAnswers = List.of([]);
  final int paging = 2; // The number of sub answers to be displayed when user tries loading more sub-answers
  final ValueNotifier<int> listedAnswerItemCount = ValueNotifier<int>(0);

  Future fetchData(EntryViewModel entryViewModel) async {
    if (model.isMainAnswer())
    {
      debugPrint("Fetching all sub answers for main answer with answerID: ${model.answerID}");
      await entryViewModel.fetchAllSubAnswers(model.answerID);
      subAnswers = entryViewModel.subAnswersMap[model.answerID]!;
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
}