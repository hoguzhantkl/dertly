import 'package:dertly/core/themes/custom_colors.dart';
import 'package:dertly/views/widgets/answer/answerlist.dart';
import 'package:dertly/views/widgets/answer/answerlistitem.dart';
import 'package:flutter/material.dart';

class EntryScreen extends StatefulWidget{
  const EntryScreen({super.key});

  @override
  State<EntryScreen> createState() => EntryScreenState();
}

class EntryScreenState extends State<EntryScreen>{
    @override
    Widget build(BuildContext context){
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: const [
                                          Icon(Icons.arrow_upward_rounded, size: 24),
                                          Text("10", style: TextStyle(fontSize: 12)),
                                        ],
                                      ),
                                      const SizedBox(width: 12),
                                      Column(
                                        children: const [
                                          Icon(Icons.arrow_downward_rounded, size: 24),
                                          Text("8", style: TextStyle(fontSize: 12)),
                                        ],
                                      ),
                                      const SizedBox(width: 12),
                                      Column(
                                        children: const [
                                          Icon(Icons.mic, size: 24),
                                          Text("8", style: TextStyle(fontSize: 12)),
                                        ],
                                      ),
                                      const SizedBox(width: 12),
                                      Column(
                                        children: const [
                                          Icon(Icons.star, size: 24),
                                          Text("8", style: TextStyle(fontSize: 12)),
                                        ],
                                      ),
                                      const SizedBox(width: 12),
                                      Column(
                                        children: const [
                                          Icon(Icons.add, size: 24),
                                          Text("8", style: TextStyle(fontSize: 12)),
                                        ],
                                      ),
                                      const SizedBox(width: 12),
                                      Column(
                                        children: const [
                                          Icon(Icons.support_rounded, size: 24),
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

                                  const Text("04/01/2023, 08:00:00", style: TextStyle(fontSize: 12)),

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
                  Padding(
                    padding: EdgeInsets.only(left: 8, right: 8),
                    child: AnswerList(
                      testAnswerListItems: [
                        AnswerListItem(
                          testAnswerListItems: [
                            AnswerListItem()
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