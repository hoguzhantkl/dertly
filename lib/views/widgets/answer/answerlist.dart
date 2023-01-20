import 'package:flutter/cupertino.dart';

import 'answerlistitem.dart';

class AnswerList extends StatefulWidget{
  const AnswerList({super.key, this.testAnswerListItems = const []});


  final List<AnswerListItem> testAnswerListItems;

  @override
  State<AnswerList> createState() => AnswerListState();

}

class AnswerListState extends State<AnswerList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(0),
      shrinkWrap: true,
      itemCount: widget.testAnswerListItems.length,
      itemBuilder: (context, index) {
        return widget.testAnswerListItems[index];
      }
    );
  }

}