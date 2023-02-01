import 'package:dertly/models/feeds_model.dart';
import 'package:dertly/view_models/feeds_viewmodel.dart';
import 'package:dertly/views/widgets/feeds/entrieslistitem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EntriesList extends StatefulWidget{
  const EntriesList({Key? key}) : super(key: key);

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
    debugPrint("Building EntriesList");
    FeedsViewModel feedsViewModel = Provider.of<FeedsViewModel>(context, listen: false);
    return FutureBuilder(
      future: feedsViewModel.fetchAllRecentEntries(),
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          return RefreshIndicator(
            onRefresh: () async {
              onRefreshList();
            },
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: feedsViewModel.model.recentEntriesMap.length,
              itemBuilder: (context, index){
                final entryID = feedsViewModel.model.recentEntriesMap.keys.elementAt(index);
                return EntriesListItem(entryID: entryID, displayedEntryCategory: EntryCategory.recents);},
            )
          );
        } else {
          return const CircularProgressIndicator();
        }
      }
    );
  }
}