import 'package:dertly/main.dart';
import 'package:dertly/views/widgets/feeds/entrieslist.dart';
import 'package:flutter/material.dart';

class FeedsWidget extends StatefulWidget {
  const FeedsWidget({super.key});

  @override
  State<FeedsWidget> createState() => FeedsWidgetState();
}

class FeedsWidgetState extends State<FeedsWidget> with SingleTickerProviderStateMixin{
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 4)..addListener(() {
      setState(() {
        debugPrint("Tab index: ${tabController.index}");
      });
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          child: TabBar(
            tabs: const [
              Tab(text: 'TRENDS'),
              Tab(text: 'RECENTS'),
              Tab(text: 'YOURTURN'),
              Tab(text: 'FOLLOWERS'),
            ],
            indicatorColor: Colors.white,
            controller: tabController,
          ),
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
          )
        ),
        
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: const <Widget>[
              Center(child: Text('TRENDS')),
              EntriesList(),
              Center(child: Text('YOURTURN')),
              Center(child: Text('FOLLOWERS')),
            ],
          ),
        )
      ],
    );
  }
}