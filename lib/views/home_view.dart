import 'package:dertly/core/themes/custom_colors.dart';
import 'package:dertly/view_models/feeds_viewmodel.dart';
import 'package:dertly/view_models/user_viewmodel.dart';
import 'package:dertly/views/profile_view.dart';
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

  final List<Widget> _widgetOptions = const <Widget>[
    FeedsScreen(),
    // TODO: Add Community, Shuffle and Message Screen
    Center(child: Text("Community Screen")),
    Center(child: Text("Shuffle Screen")),
    Center(child: Text("Message Screen")),
    ProfileScreen()
  ];

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late UserViewModel userViewModel;

  rtr.Router router = locator<rtr.Router>();

  int previousPageIndex = 0;
  int currentPageIndex = 0;
  int popCounter = 0;
  bool isAppBarVisible = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void switchPage(int index) {
    if (index == currentPageIndex) return;

    if (index == 0) {
      popCounter = 0;
    }

    previousPageIndex = currentPageIndex;
    currentPageIndex = index;
    isAppBarVisible = currentPageIndex == 0;
  }

  @override
  Widget build(BuildContext context) {
    userViewModel = Provider.of<UserViewModel>(context);

    FeedsViewModel feedsViewModel =
    Provider.of<FeedsViewModel>(context, listen: false);

    return WillPopScope(
        onWillPop: () {
          debugPrint("WillPopScope: current: $currentPageIndex previous: $previousPageIndex");
          bool willPop = currentPageIndex == 0;
          setState(() {
            if (!willPop && currentPageIndex != previousPageIndex){
              popCounter++;
              switchPage((popCounter >= 2) ? 0 : previousPageIndex);
            }
          });

          return Future.value(willPop);
        },
        child: Scaffold(
          appBar: isAppBarVisible
              ? AppBar(
            title: Text(widget.title),
            backgroundColor: Theme
                .of(context)
                .appBarTheme
                .backgroundColor,
            shadowColor: Colors.transparent,
          ) : null,
          body: IndexedStack(
            index: currentPageIndex,
            children: widget._widgetOptions,
          ),
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
            currentIndex: currentPageIndex,
            onTap: (int index) {
              setState(() {
                switchPage(index);
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
        )
    );
  }
}
