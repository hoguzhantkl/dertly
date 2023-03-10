import 'dart:io';

import 'package:dertly/view_models/feeds_viewmodel.dart';
import 'package:dertly/view_models/user_viewmodel.dart';
import 'package:dertly/views/widgets/feeds/entrieslist.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../models/feeds_model.dart';

class FeedsScreen extends StatefulWidget {
  const FeedsScreen({super.key});

  @override
  State<FeedsScreen> createState() => FeedsScreenState();
}

class FeedsScreenState extends State<FeedsScreen> with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    debugPrint("feeds_view has been initialized");
    Provider.of<FeedsViewModel>(context, listen: false).init();
    super.initState();
    tabController = TabController(vsync: this, length: 4);//..addListener(() {});
  }

  @override
  void dispose() {
    debugPrint("feeds_view has been disposed");
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).appBarTheme.backgroundColor,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).appBarTheme.shadowColor!,
                blurRadius: 5.0,
                spreadRadius: 0.0,
                offset: Offset(0.0, 2.0),
              )
            ],
          ),
          child: TabBar(
            tabs: const [
              Tab(text: 'TRENDS'),
              Tab(text: 'RECENTS'),
              Tab(text: 'YOURTURN'),
              Tab(text: 'FOLLOWERS'),
            ],
            indicatorColor: Theme.of(context).indicatorColor,
            indicatorPadding: const EdgeInsets.only(bottom: 4.0),
            controller: tabController,
          )
        ),
        
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: const <Widget>[
              EntriesList(entryCategory: EntryCategory.trendings),
              EntriesList(entryCategory: EntryCategory.recents),
              Center(child: Text('YOURTURN')),
              Center(child: Text('FOLLOWERS')),
            ],
          ),
        )
      ],
    );
  }
}