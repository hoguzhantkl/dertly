import 'dart:collection';
import 'dart:math';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:dertly/models/answer_model.dart';
import 'package:dertly/view_models/entry_viewmodel.dart';
import 'package:dertly/views/widgets/answer/answerinfos.dart';
import 'package:dertly/views/widgets/answer/userimage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/themes/custom_colors.dart';
import '../../../view_models/answer_viewmodel.dart';
import '../../../view_models/feeds_viewmodel.dart';
import '../audiowave.dart';
import 'answerlist.dart';

class AnswerListItem extends StatefulWidget
{
  const AnswerListItem({super.key, required this.answerViewModel});

  final AnswerViewModel answerViewModel;

  @override
  State<StatefulWidget> createState() => AnswerListItemState();
}

class AnswerListItemState extends State<AnswerListItem>{
  late EntryViewModel entryViewModel;
  late PlayerController playerController;

  @override
  void initState(){
    debugPrint("AnswerListItemState.initState() called for answerID: ${widget.answerViewModel.model.answerID}");
    entryViewModel = Provider.of<EntryViewModel>(context, listen: false);
    playerController = entryViewModel.createAnswerPlayerController(widget.answerViewModel.model.answerID);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final model = widget.answerViewModel.model;
    return FutureBuilder(
      future: widget.answerViewModel.fetchData(entryViewModel),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done && model != null){
          return Padding(
              padding: const EdgeInsets.only(bottom: 0),
              child: Flex(
                mainAxisAlignment: MainAxisAlignment.center,
                direction: Axis.vertical,
                children: [
                  Container(
                    //width: 400,
                    padding: const EdgeInsets.only(left: 0, right: 0),
                    //decoration: const BoxDecoration(color: Colors.red),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // maybe change to start?
                      crossAxisAlignment: CrossAxisAlignment.start,
                      //direction: Axis.horizontal,

                      children: [
                        UserImage(),

                        const SizedBox(width: 8),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [

                                  // Mentioned Answer Image for mentionedUserID
                                  Visibility(
                                      visible: model.isMentionedSubAnswer(),
                                      child: Row(
                                          children: [
                                            Icon(Icons.arrow_forward_ios_rounded, size: 18, color: Colors.white),
                                            const SizedBox(width: 4),
                                            UserImage(),
                                            const SizedBox(width: 8),
                                          ]
                                      )
                                  ),

                                  Expanded(
                                      child: AudioWave(
                                        width: model.isMainAnswer() ? audioWaveWidth : AudioWave.getAudioWaveWidthForAnswer(model.answerType),
                                        playerController: playerController,
                                        audioWaveData: model.audioWaveData!,
                                        audioDuration: model.audioDuration,
                                      ),
                                  ),

                                  // Play Button
                                  StreamBuilder(
                                      stream: playerController.onPlayerStateChanged,
                                      builder: (context, snapshot){
                                        final PlayerState playerState = (snapshot.hasData) ? snapshot.data! : PlayerState.stopped;
                                        return IconButton(
                                            onPressed: () async{
                                              onListenButtonClicked(playerState);
                                              //setState(() {});
                                            },
                                            padding: const EdgeInsets.all(0),
                                            iconSize: 36,
                                            icon: Icon(playerState.isPlaying ? Icons.pause : Icons.play_arrow, size: 36)
                                        );
                                      }
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),

                              AnswerInfos(answerModel: model),

                              const SizedBox(height: 12),

                              Row(
                                children: [
                                  Expanded(
                                    child: ValueListenableBuilder(
                                        valueListenable: widget.answerViewModel.listedAnswerItemCount,
                                        builder: (BuildContext context, int value, Widget? child) {
                                          return Visibility
                                          (
                                            visible: widget.answerViewModel.subAnswers.isNotEmpty && widget.answerViewModel.listedAnswerItemCount.value > 0,
                                            child: AnswerList(answers: widget.answerViewModel.subAnswers.sublist(0, widget.answerViewModel.listedAnswerItemCount.value)),
                                          );
                                        }
                                    ),
                                  )
                                ]
                              ),

                              // Answers to this answer
                              ValueListenableBuilder(
                                valueListenable: widget.answerViewModel.listedAnswerItemCount,
                                builder: (BuildContext context, int value, Widget? child){
                                  return Visibility(
                                      visible: widget.answerViewModel.subAnswers.isNotEmpty && widget.answerViewModel.listedAnswerItemCount.value < widget.answerViewModel.subAnswers.length,
                                      child: InkWell(
                                          onTap: (){
                                            widget.answerViewModel.listedAnswerItemCount.value = min(widget.answerViewModel.listedAnswerItemCount.value+widget.answerViewModel.paging, widget.answerViewModel.subAnswers.length);
                                          },
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                  width: 100,
                                                  height: 12,
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        width: 50,
                                                        height: 1,
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius: BorderRadius.circular(4)
                                                        ),
                                                      ),

                                                      const SizedBox(width: 4),

                                                      Icon(Icons.mic, size: 14, color: Colors.white),

                                                      Text("${widget.answerViewModel.subAnswers.length - widget.answerViewModel.listedAnswerItemCount.value}", style: TextStyle(fontSize: 12, color: Colors.white))
                                                    ],
                                                  )
                                              ),

                                              SizedBox(height: 8)
                                            ],
                                          )
                                      )
                                  );
                                }
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              )
          );
        }

        return const Center(child: CircularProgressIndicator());
      }
    );
  }

  Future onListenButtonClicked(PlayerState playerState) async{
    final model = widget.answerViewModel.model;

    final feedsViewModel = Provider.of<FeedsViewModel>(context, listen: false);

    if (playerState.isPlaying){
      await playerController.pausePlayer();
    }
    else if (playerState.isPaused){
      await feedsViewModel.pauseCurrentListeningEntryAudio();

      await playerController.startPlayer(finishMode: FinishMode.pause).then((value) async{
        entryViewModel.setCurrentListeningAnswerModel(model!);
        feedsViewModel.showBottomSheet();
      });
    }
    else {
      await feedsViewModel.pauseCurrentListeningEntryAudio();

      await entryViewModel.listenAnswer(model, model.audioUrl, playerController)
          .then((listening) {
        if (listening){
          entryViewModel.setCurrentListeningAnswerModel(model);
          feedsViewModel.showBottomSheet();
        }
      });
    }
  }
}