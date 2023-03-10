import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:dertly/view_models/feeds_viewmodel.dart';
import 'package:dertly/views/widgets/answer/mainanswerslist.dart';
import 'package:dertly/views/widgets/audiowave.dart';
import 'package:dertly/views/widgets/bottomsheet/bottomsheetwidget.dart';
import 'package:dertly/views/widgets/entry/entryinfos.dart';
import 'package:dertly/views/widgets/user/userimagebuilder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/entry_model.dart';
import '../view_models/entry_viewmodel.dart';

class EntryScreen extends StatefulWidget{
  const EntryScreen({super.key});

  @override
  State<EntryScreen> createState() => EntryScreenState();
}

class EntryScreenState extends State<EntryScreen>{

  late PlayerController playerController;
  late EntryViewModel entryViewModel;
  late FeedsViewModel feedsViewModel;

  ValueNotifier<bool> playerControllerChanged = ValueNotifier<bool>(false);

  @override
  void initState(){
    entryViewModel = Provider.of<EntryViewModel>(context, listen: false);
    feedsViewModel = Provider.of<FeedsViewModel>(context, listen: false);

    EntryModel? model = entryViewModel.model;

    if (model == null){
      debugPrint("EntryModel initState() for entry_view could not be get from entryViewModel.model, model is null");
      return;
    }

    entryViewModel.clear();

    playerController = feedsViewModel.getEntryPlayerController(model.entryID);

    // TODO: should we remove the listener when the widget is disposed?
    /*playerController.addListener(() {
      if (mounted){
        playerController = Provider.of<FeedsViewModel>(context, listen: false).getEntryPlayerController(model.entryID);
      }
    });*/

    debugPrint("no of sample for the size: ${const PlayerWaveStyle(spacing: 6).getSamplesForWidth(180)}");
    super.initState();
  }

  @override
  void dispose(){
    playerController.removeListener(() { });
    entryViewModel.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    debugPrint("Building entry_view");

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
                                /*const ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(36)),
                                  child: Image(
                                    image: AssetImage("assets/images/placeholder.png"),
                                    fit: BoxFit.cover,
                                  ),
                                ),*/

                                UserImageBuilder(
                                  userID: model.userID,
                                  borderRadius: 36,
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.width * 0.6,
                                ),

                                const SizedBox(height: 12),

                                // Entry Informations
                                const EntryInfos(),

                                const SizedBox(height: 8.0),

                                const SizedBox(height: 12),

                                ValueListenableBuilder(
                                    valueListenable: playerControllerChanged,
                                    builder: (BuildContext context, value, child){
                                      debugPrint("playerControllerChanged");
                                      return AudioWave(
                                        playerController: feedsViewModel.getEntryPlayerController(model.entryID),
                                        audioWaveData: model.audioWaveData!,
                                        audioDuration: model.audioDuration,
                                      );
                                    }
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
                                        const SizedBox(width: 12),

                                        StreamBuilder(
                                            stream: playerController.onPlayerStateChanged,
                                            initialData: playerController.playerState,
                                            builder: (context, snapshot){
                                              final PlayerState playerState = (snapshot.hasData) ? snapshot.data! : PlayerState.stopped;

                                              return IconButton(
                                                  onPressed: () async{
                                                    await Provider.of<EntryViewModel>(context, listen: false).listenEntry(model, feedsViewModel, feedsViewModel.getEntryPlayerController(model.entryID))
                                                      .then((value) {
                                                        playerControllerChanged.value = !playerControllerChanged.value;
                                                      });
                                                  },
                                                  padding: const EdgeInsets.all(0),
                                                  icon: Icon(playerState.isPlaying ? Icons.pause : Icons.play_arrow, size: 48)
                                              );
                                            }
                                        ),

                                        const SizedBox(width: 12),
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

                const Padding(
                    padding: EdgeInsets.only(left: 8, right: 8),
                    child: MainAnswersList()
                )
              ],
            ),
          ),
        )
      ),
      bottomSheet: ValueListenableBuilder(
        valueListenable: feedsViewModel.model.onBottomSheetUpdate,
        builder: (context, value, child){
          return feedsViewModel.model.isBottomSheetVisible ? const BottomSheetWidget(onTapDisabled: true) : Container(height: 0);
        }
      )
    );
  }

}