import 'package:dertly/models/answer_model.dart';
import 'package:dertly/view_models/entry_viewmodel.dart';
import 'package:dertly/view_models/feeds_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../../core/themes/custom_colors.dart';
import '../recordaudiobutton.dart';

class BottomSheetContent extends StatefulWidget {
  const BottomSheetContent({super.key});

  @override
  State<BottomSheetContent> createState() => BottomSheetContentState();
}

class BottomSheetContentState extends State<BottomSheetContent>{
  @override
  Widget build(BuildContext context){
    FeedsViewModel feedsViewModel = Provider.of<FeedsViewModel>(context);
    EntryViewModel entryViewModel = Provider.of<EntryViewModel>(context);

    return ValueListenableBuilder(
        valueListenable: feedsViewModel.model.onBottomSheetUpdate,
        builder: (context, value, child){
          String? entryID;

          var listeningEntryModel = feedsViewModel.getCurrentListeningEntryModel();
          entryID = listeningEntryModel?.entryID;

          var tempText = entryID;

          AnswerModel? listeningAnswerModel = entryViewModel.currentListeningAnswerModel;

          bool isListeningToEntry(){
            return listeningAnswerModel == null;
          }

          bool isListeningToAnswer(){
            return listeningAnswerModel != null;
          }

          if (isListeningToAnswer())
          {
            var answerID = listeningAnswerModel!.answerID;
            tempText = "$tempText - $answerID";
          }

          return Container(
            height: MediaQuery.of(context).size.height,
            // TODO: Create a BottomSheetTheme in custom_themes
            decoration: const BoxDecoration(
              color: CustomColors.foreground,
            ),
            child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: 0),
                    Text("$tempText!", style: const TextStyle(fontSize: 16)),

                    Padding(
                      padding: const EdgeInsets.only(right: 24),
                      child: RecordAudioButton(
                          heroTag: "recordAnswerAudio",
                          width: 45,
                          height: 45,
                          onRecordingFinishedCallback: () async {
                            if (isListeningToEntry())
                            {
                              await Provider.of<EntryViewModel>(context, listen: false).createMainAnswer(entryID!, AnswerType.neutral);
                            }
                            else
                            {
                              if (listeningAnswerModel!.isMainAnswer())
                              {
                                await Provider.of<EntryViewModel>(context, listen: false).createSubAnswer(entryID!, listeningAnswerModel.answerID);
                              }
                              else
                              {
                                await Provider.of<EntryViewModel>(context, listen: false).createMentionedSubAnswer(entryID!, listeningAnswerModel.answerID, listeningAnswerModel.userID);
                              }
                            }
                          }
                      ),
                    )
                  ],
                )
            ),
          );
        }
    );


  }
}