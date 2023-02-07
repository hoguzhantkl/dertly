import 'dart:collection';

import 'package:dertly/view_models/entry_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../../../models/answer_model.dart';
import '../../../view_models/answer_viewmodel.dart';
import 'answerlistitem.dart';

class SubAnswersList extends StatefulWidget{
  const SubAnswersList({super.key, required this.answers});

  final List<AnswerModel> answers;

  @override
  State<SubAnswersList> createState() => SubAnswersListState();
}

class SubAnswersListState extends State<SubAnswersList> {
  @override
  Widget build(BuildContext context) {
    debugPrint("AnswerListState, answers.length: ${widget.answers.length}");
    return ListView.builder(
        padding: const EdgeInsets.all(0),
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: widget.answers.length,
        itemBuilder: (context, index) {
          debugPrint("AnswerListState, index: $index");
          AnswerModel answerModel = widget.answers.elementAt(index); // widget.answersMap[widget.answersMap.keys.elementAt(index)]!;
          debugPrint("AnswerListState, answerModel.answerID: ${answerModel.answerID}, mentionedAnswerID: ${answerModel.mentionedAnswerID}");
          return AnswerListItem(answerViewModel: AnswerViewModel(model: answerModel));
        }
    );
  }

}