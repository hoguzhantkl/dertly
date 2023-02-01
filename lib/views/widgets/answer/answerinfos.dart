import 'package:dertly/models/answer_model.dart';
import 'package:flutter/material.dart';

class AnswerInfos extends StatelessWidget{
  const AnswerInfos({super.key, required this.answerModel});

  final AnswerModel answerModel;

  @override
  Widget build(BuildContext context) {
    return Row(
        children: [

          Row(
            children: [
              Icon(Icons.arrow_upward_rounded, size: 14, color: Colors.white),
              Text("${answerModel.getTotalUpVotesCount()}", style: TextStyle(fontSize:12, color: Colors.white)),
            ],
          ),
          SizedBox(width: 20),
          Row(
            children: [
              Icon(Icons.arrow_downward_rounded, size: 14, color: Colors.white),
              Text("${answerModel.getTotalDownVotesCount()}", style: TextStyle(fontSize:12, color: Colors.white)),
            ],
          ),
          SizedBox(width: 20),

          // TODO: show answer type if answer is for entry. (answer is not for another answer)
          /*
          Visibility(
            visible: mentionedAnswerID.isEmpty,
            child: Icon(Icons.dangerous_outlined, size: 14, color: Colors.redAccent),
          ),
          SizedBox(width: 20),
           */

          Text(answerModel.date.toDate().toString(), style: TextStyle(fontSize: 10, color: Colors.white))

        ]
    );
  }

}