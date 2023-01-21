import 'dart:math';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:dertly/views/widgets/answer/answerinfos.dart';
import 'package:dertly/views/widgets/answer/userimage.dart';
import 'package:flutter/material.dart';

import '../../../core/themes/custom_colors.dart';
import '../audiowave.dart';
import 'answerlist.dart';

class AnswerListItem extends StatefulWidget
{
  const AnswerListItem({super.key, this.testAnswerListItems = const [], this.mentionedAnswer = false});

  final hasAnswer = true;
  final mentionedAnswer;

  final List<AnswerListItem> testAnswerListItems;

  @override
  State<StatefulWidget> createState() => AnswerListItemState();

}

class AnswerListItemState extends State<AnswerListItem>{
  int paging = 2;
  final ValueNotifier<int> listedAnswerItemCount = ValueNotifier<int>(0);

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
                              visible: widget.mentionedAnswer,
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
                                visible: widget.testAnswerListItems.isNotEmpty && listedAnswerItemCount.value > 0,
                                child: AnswerList(testAnswerListItems: widget.testAnswerListItems.sublist(0, listedAnswerItemCount.value)),
                              );
                            }
                        ),

                        // Answers to this answer
                        Visibility(
                            visible: widget.testAnswerListItems.isNotEmpty && listedAnswerItemCount.value < widget.testAnswerListItems.length,
                            child: InkWell(
                                onTap: (){
                                  setState(() {
                                    listedAnswerItemCount.value = min(listedAnswerItemCount.value+paging, widget.testAnswerListItems.length);
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

                                            Text("${widget.testAnswerListItems.length - listedAnswerItemCount.value}", style: TextStyle(fontSize: 12, color: Colors.white))
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