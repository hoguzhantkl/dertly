import 'dart:ui';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:dertly/core/themes/custom_colors.dart';
import 'package:dertly/models/feeds_model.dart';
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
  const EntriesListItem({super.key, required this.entryID, required this.displayedEntryCategory});

  final String entryID;
  final EntryCategory displayedEntryCategory;

  @override
  State<EntriesListItem> createState() => EntriesListItemState();
}

class EntriesListItemState extends State<EntriesListItem>{
  late PlayerController playerController;

  @override
  void initState(){
    playerController = Provider.of<FeedsViewModel>(context, listen: false).createEntryPlayerController(widget.entryID);
    super.initState();
  }

  EntryModel? getModel(){
    return Provider.of<FeedsViewModel>(context, listen: false).getEntryModel(widget.entryID, widget.displayedEntryCategory);
  }

  @override
  Widget build(BuildContext context) {
    final EntryModel? model = getModel();

    if (model == null)
    {
      debugPrint("EntryModel for entrieslistitem could not be get from feedsViewModel.getEntryModel for entryID: ${widget.entryID}, model is null");
      return const SizedBox(width: 0, height: 0);
    }

    return Flex(
      direction: Axis.vertical,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 0.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const UserImage(width: 56, height: 56, borderRadius: 6),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        StreamBuilder(
                            stream: playerController.onPlayerStateChanged,
                            builder: (context, snapshot){
                              final PlayerState playerState = (snapshot.hasData) ? snapshot.data! : PlayerState.stopped;

                              return IconButton(
                                  onPressed: () async{
                                    await onListenButtonClicked(playerState);
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
                                audioWaveData: model.audioWaveData!,
                                audioDuration: model.audioDuration,
                              )
                          ),
                        )

                      ],
                    ),

                    const SizedBox(height: 4),

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

  Future onListenButtonClicked(PlayerState playerState) async{
    final feedsViewModel = Provider.of<FeedsViewModel>(context, listen: false);
    final entryViewModel = Provider.of<EntryViewModel>(context, listen: false);

    final model = getModel();

    if (model == null){
      return;
    }

    if (playerState.isPlaying){
      await playerController.pausePlayer();
    }
    else if (playerState.isPaused){
      await feedsViewModel.setCurrentListeningEntryID(model.entryID);
      await playerController.startPlayer(finishMode: FinishMode.pause).then((value) async{
        entryViewModel.clearCurrentListeningAnswerModel();
      });
    }
    else {
      await feedsViewModel.listenEntry(model.entryID, model.audioUrl, playerController)
          .then((listening) {
        if (listening){
          entryViewModel.clearCurrentListeningAnswerModel();
        }
      });
    }
  }
}