import 'package:dertly/core/routes/routing_constants.dart';
import 'package:dertly/view_models/user_viewmodel.dart';
import 'package:dertly/views/recorder_view.dart';
import 'package:dertly/views/widgets/feeds/feedswidget.dart';

import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../locator.dart';
import '../view_models/auth_viewmodel.dart';

import '../core/routes/router.dart' as rtr;
import '../core/routes/routing_constants.dart';

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
  Widget build(BuildContext context) {
    AuthViewModel authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    userViewModel = Provider.of<UserViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.green,
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
            backgroundColor: Colors.green,
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: null,
            onPressed: (){
              router.navigateTo(recorderRoute);
            },
            tooltip: 'Go to Recording Page',
            backgroundColor: Colors.green,
            child: const Icon(Icons.route),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: null,
            onPressed: () {
              authViewModel.signOut();
            },
            tooltip: 'Sign Out',
            backgroundColor: Colors.green,
            child: const Icon(Icons.logout),
          ),
        ],
      ),
    );
  }
}