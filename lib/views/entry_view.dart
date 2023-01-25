import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:dertly/core/themes/custom_colors.dart';
import 'package:dertly/view_models/feeds_viewmodel.dart';
import 'package:dertly/views/widgets/answer/answerlist.dart';
import 'package:dertly/views/widgets/answer/answerlistitem.dart';
import 'package:dertly/views/widgets/audiowave.dart';
import 'package:dertly/views/widgets/entry/entryinfos.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../locator.dart';
import '../models/entry_model.dart';
import '../view_models/entry_viewmodel.dart';

class EntryScreen extends StatefulWidget{
  const EntryScreen({super.key});

  @override
  State<EntryScreen> createState() => EntryScreenState();
}

class EntryScreenState extends State<EntryScreen>{
    @override
    void initState(){
      super.initState();
    }

    @override
    Widget build(BuildContext context){
      EntryViewModel entryViewModel = Provider.of<EntryViewModel>(context, listen: false);
      EntryModel? model = entryViewModel.model;

      if (model == null){
        debugPrint("EntryModel for entry_view could not be get from entryViewModel.model, model is null");
        return const SizedBox(width: 0, height: 0);
      }

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
                            padding: const EdgeInsets.only(left: 42, right: 42, top: 8),
                            child: Column(
                                children: [
                                  const ClipRRect(
                                    borderRadius: BorderRadius.all(Radius.circular(36)),
                                    child: Image(
                                      image: AssetImage("assets/images/placeholder.png"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),

                                  const SizedBox(height: 12),

                                  // Entry Informations
                                  const EntryInfos(),

                                  const SizedBox(height: 8.0),

                                  const SizedBox(height: 12),

                                  AudioWave(
                                      playerController: PlayerController(),
                                      audioWaveData: model.audioWaveData!,
                                      audioDuration: model.audioDuration,
                                  ),

                                  const SizedBox(height: 8),

                                  Text(model.date.toDate().toString(), style: const TextStyle(fontSize: 12)),

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

                  Padding(
                    padding: EdgeInsets.only(left: 8, right: 8),
                    child: AnswerList(answers: entryViewModel.answers),
                  )

                ],
              ),
            ),
          )
        )
      );
    }

}