import 'package:dertly/models/feeds_model.dart';
import 'package:dertly/view_models/feeds_viewmodel.dart';
import 'package:dertly/views/widgets/feeds/entrieslistitem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EntriesList extends StatefulWidget{
  const EntriesList({Key? key, required this.entryCategory}) : super(key: key);

  final EntryCategory entryCategory;

  @override
  State<EntriesList> createState() => EntriesListState();
}

class EntriesListState extends State<EntriesList> with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  void onRefreshList() async {
    debugPrint("onRefreshList");
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    debugPrint("Building EntriesList for category: ${widget.entryCategory}");
    FeedsViewModel feedsViewModel = Provider.of<FeedsViewModel>(context, listen: false);
    return FutureBuilder(
      future: feedsViewModel.fetchEntriesForCategory(widget.entryCategory),
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          var entriesMap = feedsViewModel.getEntriesMapForCategory(widget.entryCategory);

          return RefreshIndicator(
            onRefresh: () async {
              onRefreshList();
            },
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: entriesMap.length,
              itemBuilder: (context, index){
                final entryID = entriesMap.keys.elementAt(index);
                return EntriesListItem(entryID: entryID, displayedEntryCategory: widget.entryCategory);},
            )
          );
        } else {
          return const CircularProgressIndicator();
        }
      }
    );
  }
}