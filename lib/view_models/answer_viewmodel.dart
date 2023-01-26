import 'package:dertly/view_models/entry_viewmodel.dart';
import 'package:flutter/material.dart';

import '../models/answer_model.dart';

class AnswerViewModel {
  AnswerViewModel({required this.model});

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
}