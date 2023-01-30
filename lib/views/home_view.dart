import 'package:dertly/core/themes/custom_colors.dart';
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

  int currentPage = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    userViewModel = Provider.of<UserViewModel>(context);

    FeedsViewModel feedsViewModel =
        Provider.of<FeedsViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        shadowColor: Colors.transparent,
      ),
      body: currentPage == 0 ? const FeedsScreen() : Scaffold(),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          RecordAudioButton(
              heroTag: "recordEntryAudio",
              onRecordingFinishedCallback: () async {
                await Provider.of<FeedsViewModel>(context, listen: false)
                    .createEntry();
              }),
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
          builder: (context, value, child) {
            return feedsViewModel.model.isBottomSheetVisible
                ? const BottomSheetWidget()
                : Container(height: 0);
          }),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentPage,
        onTap: (int index) {
          setState(() {
            currentPage = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
            //backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_sharp),
            label: "Community",
            //backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shuffle_sharp),
            label: "Shuffle",
            //backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: "Messages / DM",
            //backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
            //backgroundColor: Colors.red,
          ),
        ],
        backgroundColor: Colors.black,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: CustomColors.green,
        unselectedItemColor: CustomColors.beige,
        iconSize: 32,
      ),
    );
  }
}
