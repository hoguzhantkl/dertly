import 'package:flutter/material.dart';

import '../../../locator.dart';
import '../../../services/entry_service.dart';

class EntriesListItem extends StatelessWidget{
  const EntriesListItem({super.key, required this.entryID, required this.contentUrl,
                this.upVote, this.downVote, this.totalAnswers});

  final String entryID;
  final String? contentUrl;
  final int? upVote;
  final int? downVote;
  final int? totalAnswers;

  @override
  Widget build(BuildContext context) {
    var entryService = locator<EntryService>();

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 4.0, bottom: 4.0),
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
                          IconButton(
                              onPressed: (){
                                  entryService.listenEntryContentAudio(contentUrl);
                                  },
                              icon: const Icon(Icons.play_arrow, size: 42)
                          ),
                          Padding(
                              padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                              child: Text("...", style: Theme.of(context).textTheme.subtitle1)
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              const Icon(Icons.arrow_upward, size: 20),
                              Text(upVote.toString())
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              const Icon(Icons.arrow_downward, size: 20),
                              Text(downVote.toString())
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              const Icon(Icons.mic, size: 20),
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