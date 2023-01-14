import 'package:flutter/material.dart';

class EntriesListItem extends StatelessWidget{
  const EntriesListItem({super.key, required this.entryID, required this.entryContent,
                this.upVote, this.downVote, this.totalAnswers});

  final String entryID;
  final String? entryContent;
  final int? upVote;
  final int? downVote;
  final int? totalAnswers;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: <Widget>[
              Icon(Icons.account_circle, size: 64),
              Expanded(
                child: SizedBox(
                  height: 68,
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          const SizedBox(width: 4.0),
                          IconButton(onPressed: (){}, icon: const Icon(Icons.play_arrow, size: 42)),
                          Padding(
                              padding: EdgeInsets.only(top: 8.0, left: 8.0),
                              child: Text("$entryContent", style: TextStyle(fontSize: 18.0))
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              const Icon(Icons.arrow_upward, size: 20),
                              const SizedBox(width: 4.0),
                              Text(upVote.toString())
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              const Icon(Icons.arrow_downward, size: 20),
                              const SizedBox(width: 4.0),
                              Text(downVote.toString())
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              const Icon(Icons.mic, size: 20),
                              const SizedBox(width: 4.0),
                              Text(totalAnswers.toString())
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              )
            ],
          ),
        ),
        Divider()
      ],
    );
  }
}