import 'package:dertly/core/routes/routing_constants.dart';
import 'package:dertly/services/audio_service.dart';
import 'package:dertly/view_models/feeds_viewmodel.dart';
import 'package:dertly/view_models/user_viewmodel.dart';
import 'package:dertly/views/recorder_view.dart';
import 'package:dertly/views/widgets/bottomsheet/bottomsheetwidget.dart';
import 'package:dertly/views/feeds_view.dart';

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
    debugPrint("HomeScreen Dispose");
    // TODO: find a way of dispose audioService to close Recorder
    //locator<AudioService>().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthViewModel authViewModel = Provider.of<AuthViewModel>(context, listen: false);

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
          FloatingActionButton(
            heroTag: null,
            onPressed: (){
              router.navigateTo(createEntryRoute);
            },
            tooltip: 'Entry Tests',
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: null,
            onPressed: (){
              router.navigateTo(recorderRoute);
            },
            tooltip: 'Go to Recording Page',
            child: const Icon(Icons.route),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: null,
            onPressed: () {
              authViewModel.signOut();
            },
            tooltip: 'Sign Out',
            child: const Icon(Icons.logout),
          ),
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