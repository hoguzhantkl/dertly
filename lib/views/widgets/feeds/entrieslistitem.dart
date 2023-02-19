import 'dart:io';
import 'dart:ui';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:dertly/core/themes/custom_colors.dart';
import 'package:dertly/models/feeds_model.dart';
import 'package:dertly/services/audio_service.dart';
import 'package:dertly/services/user_service.dart';
import 'package:dertly/view_models/entry_viewmodel.dart';
import 'package:dertly/views/widgets/audiowave.dart';
import 'package:dertly/views/widgets/user/userimagebuilder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../locator.dart';
import '../../../models/entry_model.dart';
import '../../../services/entry_service.dart';
import '../../../view_models/feeds_viewmodel.dart';
import '../user/userimage.dart';

class EntriesListItem extends StatefulWidget{
  const EntriesListItem({super.key, this.entryModel, required this.entryID, required this.displayedEntryCategory});

  final EntryModel? entryModel;
  final String entryID;
  final EntryCategory displayedEntryCategory;

  @override
  State<EntriesListItem> createState() => EntriesListItemState();
}

class EntriesListItemState extends State<EntriesListItem>{
  late PlayerController? playerController;
  FeedsViewModel? feedsViewModel;

  UserService userService = locator<UserService>();

  @override
  void initState(){
    feedsViewModel = Provider.of<FeedsViewModel>(context, listen: false);
    playerController = Provider.of<FeedsViewModel>(context, listen: false).getEntryPlayerController(widget.entryID);
    super.initState();
  }

  @override
  void dispose(){
    //feedsViewModel?.disposeEntryPlayerController(widget.entryID);
    super.dispose();
  }

  /*
  EntryModel? getModel(){
    if (widget.entryModel != null) {
      return widget.entryModel;
    }

    return Provider.of<FeedsViewModel>(context, listen: false).getEntryModel(widget.entryID, widget.displayedEntryCategory);
  }
  */

  @override
  Widget build(BuildContext context) {
    debugPrint("EntriesListItem build()");
    final EntryViewModel entryViewModel = Provider.of<EntryViewModel>(context, listen: false);
    final EntryModel? model = widget.entryModel;

    if (model == null)
    {
      debugPrint("EntryModel for entrieslistitem could not be get from feedsViewModel.getEntryModel for entryID: ${widget.entryID}, model is null");
      return const SizedBox(width: 0, height: 0);
    }

    return Flex(
      direction: Axis.vertical,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 2.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              UserImageBuilder(userID: model.userID, width: 56, height: 56),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        StreamBuilder(
                            stream: playerController?.onPlayerStateChanged,
                            builder: (context, snapshot){
                              final PlayerState playerState = (snapshot.hasData) ? snapshot.data! : PlayerState.stopped;

                              return IconButton(
                                  onPressed: () async
                                  {
                                    await Provider.of<EntryViewModel>(context, listen: false).listenEntry(model, entryCategory: widget.displayedEntryCategory, Provider.of<FeedsViewModel>(context, listen: false), playerController);
                                  },
                                  icon: Icon(playerState.isPlaying ? Icons.pause : Icons.play_arrow, size: 42)
                              );
                            }
                        ),

                        SizedBox(
                          width: 270,
                          child: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Visibility(
                                visible: playerController != null,
                                child: AudioWave(
                                  playerController: playerController!,
                                  audioWaveData: model.audioWaveData!,
                                  audioDuration: model.audioDuration,
                                )
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
                            InkWell(
                              onTap: () async{
                                await entryViewModel.giveUpVote(model.entryID);
                              },
                              child: Icon(Icons.arrow_upward, size: 20),
                            ),
                            Text(model.getTotalUpVotesCount().toString())
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            InkWell(
                              onTap: () async{
                                await entryViewModel.giveDownVote(model.entryID);
                              },
                              child: Icon(Icons.arrow_downward, size: 20),
                            ),
                            Text(model.getTotalDownVotesCount().toString())
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            const Icon(Icons.mic, size: 20),
                            Text(model.getTotalAnswersCount().toString())
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