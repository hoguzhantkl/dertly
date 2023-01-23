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
import '../audiowave.dart';
import 'answerlist.dart';

class AnswerListItem extends StatefulWidget
{
  const AnswerListItem({super.key, required this.answerID, required this.mentionedAnswerID});

  final String answerID;
  final String mentionedAnswerID;

  final int paging = 2; // The number of sub answers to be displayed when user tries loading more sub-answers

  @override
  State<StatefulWidget> createState() => AnswerListItemState();

}

class AnswerListItemState extends State<AnswerListItem>{
  final ValueNotifier<int> listedAnswerItemCount = ValueNotifier<int>(0);

  late EntryViewModel entryViewModel;
  late AnswerModel answerModel;
  List<AnswerModel> subAnswers = List.of([]);

  bool isMainAnswer(){
    return widget.mentionedAnswerID == "";
  }

  bool isMentionedSubAnswer(){
    return answerModel.mentionedUserID != "";
  }

  void getSubAnswerModel(){
    var subAnswerModelsList = entryViewModel.subAnswersMap[widget.mentionedAnswerID]!;
    for (var subAnswerModel in subAnswerModelsList)
    {
      if (subAnswerModel.answerID == widget.answerID)
      {
        answerModel = subAnswerModel;
        break;
      }
    }
  }

  @override
  void initState() async{
    entryViewModel = Provider.of<EntryViewModel>(context, listen: false);
    if (isMainAnswer())
    {
      answerModel = entryViewModel.answers.firstWhere((answer) => answer.answerID == widget.answerID);
      await entryViewModel.fetchAllSubAnswers(widget.answerID);
      subAnswers = entryViewModel.subAnswersMap[widget.answerID]!;
    }
    else{
      getSubAnswerModel();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: Flex(
        //mainAxisAlignment: MainAxisAlignment.start,
        direction: Axis.vertical,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 0, right: 4),
              //decoration: const BoxDecoration(color: Colors.red),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UserImage(),

                  const SizedBox(width: 7),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [

                            // Mentioned Answer
                            Visibility(
                              visible: isMentionedSubAnswer(),
                              child: Row(
                                  children: [
                                    Icon(Icons.arrow_forward_ios_rounded, size: 18, color: Colors.white),
                                    const SizedBox(width: 4),
                                    UserImage(),
                                    const SizedBox(width: 8),
                                  ]
                              )
                            ),

                            // TODO: Edit this AudioWave
                            Expanded(
                              child: AudioWave(
                                playerController: PlayerController(),
                                audioWaveData: answerModel.audioWaveData!,
                              )
                            )
                          ],
                        ),
                        const SizedBox(height: 6),

                        const AnswerInfos(),

                        const SizedBox(height: 12),

                        ValueListenableBuilder(
                            valueListenable: listedAnswerItemCount,
                            builder: (BuildContext context, int value, Widget? child) {
                              return Visibility
                              (
                                visible: subAnswers.isNotEmpty && listedAnswerItemCount.value > 0,
                                child: AnswerList(answers: subAnswers.sublist(0, listedAnswerItemCount.value)),
                              );
                            }
                        ),

                        // Answers to this answer
                        Visibility(
                            visible: subAnswers.isNotEmpty && listedAnswerItemCount.value < subAnswers.length,
                            child: InkWell(
                                onTap: (){
                                  setState(() {
                                    listedAnswerItemCount.value = min(listedAnswerItemCount.value+widget.paging, subAnswers.length);
                                  });
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

                                            Text("${subAnswers.length - listedAnswerItemCount.value}", style: TextStyle(fontSize: 12, color: Colors.white))
                                          ],
                                        )
                                    ),

                                    SizedBox(height: 8)
                                  ],
                                )
                            )
                        ),
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

}