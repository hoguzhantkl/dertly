import 'package:dertly/view_models/feeds_viewmodel.dart';
import 'package:dertly/views/widgets/bottomsheet/bottomsheetcontent.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../locator.dart';
import '../../../core/routes/router.dart' as rtr;

import '../../../core/themes/custom_colors.dart';
import '../../../view_models/entry_viewmodel.dart';

class BottomSheetWidget extends StatefulWidget {
  const BottomSheetWidget({super.key});

  @override
  State<BottomSheetWidget> createState() => BottomSheetWidgetState();
}

class BottomSheetWidgetState extends State<BottomSheetWidget>{
  final double initialChildSize = 0.08;
  late double currentChildSize;

  @override
  void initState() {
    super.initState();
    currentChildSize = initialChildSize;
  }

  void _onBottomSheetClicked(){
    setState(() {
      var feedsViewModel = Provider.of<FeedsViewModel>(context, listen: false);
      var entryViewModel = Provider.of<EntryViewModel>(context, listen: false);

      entryViewModel.setEntryModel(feedsViewModel.getCurrentListeningEntryModel());

      // TODO: Navigate to entry view by scrolling to top from bottom
      locator<rtr.Router>().navigateEntryScreen();
    });
  }

  @override
  Widget build(BuildContext context){
    return DraggableScrollableSheet(
      expand: false,
      builder: (BuildContext context, ScrollController scrollController) {
        return InkWell(
          onTap: _onBottomSheetClicked,
          child: const BottomSheetContent()
        );
      },
      minChildSize: initialChildSize,
      initialChildSize: currentChildSize,
      maxChildSize: 1.0,
    );
  }
}