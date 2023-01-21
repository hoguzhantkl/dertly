import 'dart:ui';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:dertly/core/themes/custom_colors.dart';
import 'package:dertly/services/audio_service.dart';
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
  bool isBottomSheetVisible = false;

  // TOOD: Move this to feedModel with entryID as key to avoid stopping while disposing this widget
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
    var audioService = locator<AudioService>();

    var feedsViewModel = Provider.of<FeedsViewModel>(context, listen: false);

    return Flex(
      direction: Axis.vertical,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 4.0),
          child: Row(
            children: <Widget>[
              //const Icon(Icons.account_box, size: 68),
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
                                      await feedsViewModel.onEntryListenButtonClicked(model.entryID, model.contentAudioUrl, playerController);
                                      debugPrint("noOfsamples::: ${PlayerWaveStyle(spacing: 6).getSamplesForWidth(270)}");
                                    }
                                    setState(() {});
                                  },
                                  icon: Icon(playerState.isPlaying ? Icons.pause : Icons.play_arrow, size: 42)
                              );
                            }
                        ),

                        /*
                        Container(
                          margin: const EdgeInsets.only(top: 10.0),
                          child: IconButton(
                              onPressed: () async {
                                  await feedsViewModel.onEntryCreateTestAnswerButtonClicked(model.entryID);
                                  setState(() {});
                                },
                              icon: Icon(audioService.recorder.isRecording ? Icons.stop : Icons.mic, size: 34)
                          ),
                        ),*/

                        SizedBox(
                          width: 270,
                          child: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: AudioFileWaveforms(
                                size: Size(270, 30), //MediaQueryData.fromWindow(window).size.width
                                playerController: playerController,
                                enableSeekGesture: true,
                                waveformType: WaveformType.fitWidth,
                                waveformData: (model.contentAudioWaveData != null) ? model.contentAudioWaveData! : [],
                                playerWaveStyle: const PlayerWaveStyle(
                                  liveWaveColor: CustomColors.green,
                                  spacing: 6,
                                ),
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