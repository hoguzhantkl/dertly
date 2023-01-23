import 'dart:collection';

import 'package:dertly/view_models/entry_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../../models/answer_model.dart';
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
    return ListView.builder(
      padding: const EdgeInsets.all(0),
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: widget.answers.length,
      itemBuilder: (context, index) {
        AnswerModel answerModel = widget.answers[index]; // widget.answersMap[widget.answersMap.keys.elementAt(index)]!;
        return AnswerListItem(answerID: answerModel.answerID, mentionedAnswerID: answerModel.mentionedAnswerID);
      }
    );
  }

}