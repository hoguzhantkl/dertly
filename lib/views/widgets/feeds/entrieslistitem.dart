import 'dart:ui';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:dertly/core/themes/custom_colors.dart';
import 'package:dertly/services/audio_service.dart';
import 'package:dertly/view_models/entry_viewmodel.dart';
import 'package:dertly/views/widgets/audiowave.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../locator.dart';
import '../../../models/entry_model.dart';
import '../../../services/entry_service.dart';
import '../../../view_models/feeds_viewmodel.dart';
import '../answer/userimage.dart';

class EntriesListItem extends StatefulWidget{
  const EntriesListItem({super.key, required this.entryModel});

  final EntryModel entryModel;

  @override
  State<EntriesListItem> createState() => EntriesListItemState();
}

class EntriesListItemState extends State<EntriesListItem>{
  // TODO: Move this to feedsModel with entryID as key to avoid stopping while disposing this widget
  late PlayerController playerController;

  @override
  void initState(){
    super.initState();
    playerController = PlayerController();
  }

  @override
  void dispose(){
    super.dispose();
    playerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = widget.entryModel;

    final feedsViewModel = Provider.of<FeedsViewModel>(context, listen: false);
    final entryViewModel = Provider.of<EntryViewModel>(context, listen: false);

    return Flex(
      direction: Axis.vertical,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 4.0),
          child: Row(
            children: <Widget>[
              const UserImage(width: 56, height: 56, borderRadius: 6),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        StreamBuilder(
                            stream: playerController.onPlayerStateChanged,
                            builder: (context, snapshot){
                              final PlayerState playerState = (snapshot.hasData) ? snapshot.data! : PlayerState.stopped;
                              return IconButton(
                                  onPressed: () async{
                                    if (playerState.isPlaying){
                                      playerController.pausePlayer();
                                    }
                                    else if (playerState.isPaused){
                                      playerController.startPlayer();
                                    }
                                    else {
                                      await feedsViewModel.listenEntry(model.entryID, model.contentAudioUrl, playerController);
                                    }
                                    setState(() {});
                                  },
                                  icon: Icon(playerState.isPlaying ? Icons.pause : Icons.play_arrow, size: 42)
                              );
                            }
                        ),

                        SizedBox(
                          width: 270,
                          child: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: AudioWave(
                                playerController: playerController,
                                audioWaveData: model.contentAudioWaveData!,
                              )
                          ),
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