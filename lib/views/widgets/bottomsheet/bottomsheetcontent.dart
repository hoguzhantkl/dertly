import 'package:dertly/view_models/entry_viewmodel.dart';
import 'package:dertly/view_models/feeds_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../../core/themes/custom_colors.dart';

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
          String? answerID;

          var listeningEntryModel = feedsViewModel.getCurrentListeningEntryModel();
          entryID = listeningEntryModel?.entryID;

          var tempText = entryID;

          // User is listening to an answer
          if (entryViewModel.currentListeningAnswerID != "")
          {
            answerID = entryViewModel.currentListeningAnswerID;
            tempText = "$tempText - $answerID";
          }

          return Container(
            height: MediaQuery.of(context).size.height,
            // TODO: Create a BottomSheetTheme in custom_themes
            decoration: const BoxDecoration(
              color: CustomColors.foreground,
            ),
            child: Center(
                child: Text("$tempText!", style: const TextStyle(fontSize: 16))
            ),
          );
        }
    );


  }
}