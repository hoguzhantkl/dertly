import 'package:dertly/core/routes/routing_constants.dart';
import 'package:dertly/view_models/user_viewmodel.dart';
import 'package:dertly/views/recorder_view.dart';
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

  int _counter = 0;

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
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            Text(
              'Your user id is:',
              style: Theme.of(context).textTheme.headline5,
            ),
            Text(
              '${userViewModel.userModel?.userID}',
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            heroTag: null,
            onPressed: (){
              router.navigateTo(createEntryRoute);
            },
            tooltip: 'Create a new Entry',
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
    );
  }
}