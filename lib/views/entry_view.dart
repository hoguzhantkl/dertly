import 'package:dertly/core/themes/custom_colors.dart';
import 'package:dertly/view_models/feeds_viewmodel.dart';
import 'package:dertly/views/widgets/answer/answerlist.dart';
import 'package:dertly/views/widgets/answer/answerlistitem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../locator.dart';
import '../models/entry_model.dart';

class EntryScreen extends StatefulWidget{
  const EntryScreen({super.key});

  @override
  State<EntryScreen> createState() => EntryScreenState();
}

class EntryScreenState extends State<EntryScreen>{
    @override
    void initState() {
      super.initState();
    }

    @override
    Widget build(BuildContext context){
      FeedsViewModel feedsViewModel = Provider.of<FeedsViewModel>(context, listen: false);
      EntryModel listeningEntryModel = feedsViewModel.getCurrentListeningEntryModel()!;

      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0).copyWith(top: 32.0),
              child: Column(
                children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(onPressed: (){Navigator.of(context).pop();}, icon: const Icon(Icons.arrow_back_rounded, size: 28)),
                        const Text("Now Listening", style: TextStyle(fontSize: 16)),
                        IconButton(onPressed: (){}, icon: const Icon(Icons.more_vert_rounded, size: 26)),
                      ]
                  ),
                  Column(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(left: 42, right: 42, top: 8),
                            child: Column(
                                children: [
                                  const ClipRRect(
                                    borderRadius: BorderRadius.all(Radius.circular(36)),
                                    child: Image(
                                      image: AssetImage("assets/images/placeholder.png"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),

                                  SizedBox(height: 12),

                                  // Entry Info
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                        children: [
                                          Icon(Icons.arrow_upward_rounded, size: 24),
                                          Text("${listeningEntryModel.upVote}", style: TextStyle(fontSize: 12)),
                                        ],
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        children: [
                                          Icon(Icons.arrow_downward_rounded, size: 24),
                                          Text("${listeningEntryModel.downVote}", style: TextStyle(fontSize: 12)),
                                        ],
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        children: [
                                          Icon(Icons.mic, size: 24),
                                          Text("${listeningEntryModel.totalAnswers}", style: TextStyle(fontSize: 12)),
                                        ],
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        children: const [
                                          Icon(Icons.star, size: 24, color: Colors.amberAccent),
                                          // TODO: create score in entryModel
                                          Text("8", style: TextStyle(fontSize: 12)),
                                        ],
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        children: const [
                                          Icon(Icons.add, size: 24, color: Colors.green),
                                          Text("8", style: TextStyle(fontSize: 12)),
                                        ],
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        children: const [
                                          Icon(Icons.support_rounded, size: 24, color: Colors.grey),
                                          Text("8", style: TextStyle(fontSize: 12)),
                                        ],
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,

                                        children: const [
                                          Icon(Icons.dangerous_outlined, size: 24, color: Colors.red),
                                          Text("8", style: TextStyle(fontSize: 12)),
                                        ],
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 8.0),

                                  //Text("Audio username", style: TextStyle(fontSize: 12)),
                                  const SizedBox(height: 12),

                                  // TODO: Add Waveform
                                  Container(
                                    height: 32,
                                    decoration: BoxDecoration(color: CustomColors.foreground2.withOpacity(0.5)),

                                  ),

                                  const SizedBox(height: 8),

                                  Text("${listeningEntryModel.date.toDate()}", style: TextStyle(fontSize: 12)),

                                  const SizedBox(height: 8),

                                  SizedBox(
                                      width: 200,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          IconButton(onPressed: (){}, icon: const Icon(Icons.skip_previous_rounded, size: 36)),
                                          SizedBox(width: 12),
                                          IconButton(onPressed: (){}, padding: const EdgeInsets.all(0), icon: const Icon(Icons.play_circle_rounded, size: 48)),
                                          SizedBox(width: 12),
                                          IconButton(onPressed: (){}, icon: const Icon(Icons.skip_next_rounded, size: 36)),
                                        ],
                                      )
                                  )
                                ]
                            )
                        ),

                      ]
                  ),

                  const SizedBox(height: 8),

                  // TODO: Add a ListView for Answers
                  const Padding(
                    padding: EdgeInsets.only(left: 8, right: 8),
                    child: AnswerList(
                      testAnswerListItems: [
                        AnswerListItem(
                          testAnswerListItems: [
                            AnswerListItem(),
                            AnswerListItem(mentionedAnswer: true),
                            AnswerListItem(),
                            AnswerListItem(),
                            AnswerListItem(),
                            AnswerListItem(),
                          ],
                        ),
                        AnswerListItem(),
                      ],
                    )
                  )

                ],
              ),
            ),
          )
        )
      );
    }

}