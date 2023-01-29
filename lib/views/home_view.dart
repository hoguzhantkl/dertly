import 'package:dertly/view_models/feeds_viewmodel.dart';
import 'package:dertly/view_models/user_viewmodel.dart';
import 'package:dertly/views/widgets/bottomsheet/bottomsheetwidget.dart';
import 'package:dertly/views/feeds_view.dart';
import 'package:dertly/views/widgets/recordaudiobutton.dart';

import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../locator.dart';
import '../view_models/auth_viewmodel.dart';

import '../core/routes/router.dart' as rtr;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late UserViewModel userViewModel;

  rtr.Router router = locator<rtr.Router>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    userViewModel = Provider.of<UserViewModel>(context);

    FeedsViewModel feedsViewModel = Provider.of<FeedsViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        shadowColor: Colors.transparent,
      ),
      body: const FeedsScreen(),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          RecordAudioButton(
              heroTag: "recordEntryAudio",
              onRecordingFinishedCallback: () async{
                await Provider.of<FeedsViewModel>(context, listen: false).createEntry();
              }
          ),

          const SizedBox(height: 10),

          FloatingActionButton(
            heroTag: "signOut",
            onPressed: () {
              Provider.of<AuthViewModel>(context, listen: false).signOut();
            },
            tooltip: 'Sign Out',
            child: const Icon(Icons.logout),
          ),

          const SizedBox(height: 60),
        ],
      ),

      bottomSheet: ValueListenableBuilder(
        valueListenable: feedsViewModel.model.onBottomSheetUpdate,
        builder: (context, value, child){
          return feedsViewModel.model.isBottomSheetVisible ? const BottomSheetWidget() : Container(height: 0);
        }
      ),
    );
  }
}