import 'dart:collection';

import 'package:dertly/view_models/entry_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../../models/answer_model.dart';
import '../../../view_models/answer_viewmodel.dart';
import 'answerlistitem.dart';

class AnswerList extends StatefulWidget{
  const AnswerList({super.key, this.answers = const []});

  final List<AnswerModel> answers;

  @override
  State<AnswerList> createState() => AnswerListState();
}

class AnswerListState extends State<AnswerList> {
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