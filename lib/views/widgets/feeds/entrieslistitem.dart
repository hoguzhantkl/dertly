import 'package:dertly/core/themes/custom_colors.dart';
import 'package:dertly/services/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../locator.dart';
import '../../../models/entry_model.dart';
import '../../../services/entry_service.dart';
import '../../../view_models/feeds_viewmodel.dart';

class EntriesListItem extends StatefulWidget{
  const EntriesListItem({super.key, required this.entryModel});

  final EntryModel entryModel;

  @override
  State<EntriesListItem> createState() => EntriesListItemState();
}

class EntriesListItemState extends State<EntriesListItem>{
  bool isBottomSheetVisible = false;

  @override
  Widget build(BuildContext context) {
    final model = widget.entryModel;
    var audioService = locator<AudioService>();

    var feedsViewModel = Provider.of<FeedsViewModel>(context, listen: false);

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 4.0),
          child: Row(
            children: <Widget>[
              const Icon(Icons.account_box, size: 68),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        const SizedBox(width: 4.0),
                        IconButton(
                            onPressed: () async{
                                await feedsViewModel.onEntryListenButtonClicked(model.entryID, model.contentAudioUrl);
                                setState(() {});
                              },
                            icon: const Icon(Icons.play_arrow, size: 42)
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10.0),
                          child: IconButton(
                              onPressed: () async {
                                  await feedsViewModel.onEntryCreateTestAnswerButtonClicked(model.entryID);
                                  setState(() {});
                                },
                              icon: Icon(audioService.recorder.isRecording ? Icons.stop : Icons.mic, size: 34)
                          ),
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
                            Text(model.upVote.toString())
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            const Icon(Icons.arrow_downward, size: 20),
                            Text(model.downVote.toString())
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            const Icon(Icons.mic, size: 20),
                            Text(model.totalAnswers.toString())
                          ],
                        ),
                      ],
                    ),
                  ],
                )
              )
            ],
          ),
        ),
      ],
    );
  }
}