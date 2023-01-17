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
    return Consumer<FeedsViewModel>(
      builder: (context, feedsViewModel, child){
        return Container(
            height: MediaQuery.of(context).size.height,
            // TODO: Create a BottomSheetTheme in custom_themes
            decoration: const BoxDecoration(
              color: CustomColors.foreground,
            ),
            child: Center(
              child: Text("${feedsViewModel.model.currentListeningEntryID!}!", style: TextStyle(fontSize: 16))
            ),
        );
      }
    );

  }
}