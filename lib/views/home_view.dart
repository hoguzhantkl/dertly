import 'package:dertly/core/routes/routing_constants.dart';
import 'package:dertly/services/audio_service.dart';
import 'package:dertly/view_models/feeds_viewmodel.dart';
import 'package:dertly/view_models/user_viewmodel.dart';
import 'package:dertly/views/recorder_view.dart';
import 'package:dertly/views/widgets/bottomsheet/bottomsheetwidget.dart';
import 'package:dertly/views/widgets/feeds/feedswidget.dart';

import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

import '../core/themes/custom_colors.dart';
import '../locator.dart';
import '../view_models/auth_viewmodel.dart';

import '../core/routes/router.dart' as rtr;
import '../core/routes/routing_constants.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key, required this.title});

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

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        shadowColor: Colors.transparent,
      ),
      body: const FeedsWidget(),
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
      bottomSheet: Consumer<FeedsViewModel>(
        builder: (context, feedsViewModel, child) {
          if (feedsViewModel.model.isEntryBottomSheetVisible) {
            return const BottomSheetWidget();
          }
          else {
            return Container(height: 0); //?
          }
        },
      ),
    );
  }
}