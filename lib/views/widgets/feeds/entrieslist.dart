import 'package:dertly/view_models/feeds_viewmodel.dart';
import 'package:dertly/views/widgets/feeds/entrieslistitem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EntriesList extends StatefulWidget{
  const EntriesList({Key? key}) : super(key: key);

  @override
  State<EntriesList> createState() => EntriesListState();
}

class EntriesListState extends State<EntriesList>{
  late Future future;

  @override
  void initState() {
    future = _fetchAllRecentEntries();
    super.initState();
  }

  void onRefreshList() async {
    future = _fetchAllRecentEntries();
  }

  Future _fetchAllRecentEntries() async {
    await Provider.of<FeedsViewModel>(context, listen: false).fetchAllRecentEntries();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<FeedsViewModel>(context, listen: false).fetchAllRecentEntries(),
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          return Consumer<FeedsViewModel>(
            builder: (context, feedsViewModel, child){
              return RefreshIndicator(
                onRefresh: () async {
                  debugPrint("Refreshing list");
                    onRefreshList();
                    },
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: feedsViewModel.recentEntriesMap.length,
                  itemBuilder: (context, index){
                    final entryID = feedsViewModel.recentEntriesMap.keys.elementAt(index);
                    final entryData = feedsViewModel.recentEntriesMap[entryID];
                    return EntriesListItem(
                        entryID: entryID,
                        contentUrl: entryData?.contentUrl,
                        upVote: entryData?.upVote,
                        downVote: entryData?.downVote,
                        totalAnswers: entryData?.totalAnswers);
                  },
                )
              );
            },
          );
        } else {
          return const CircularProgressIndicator();
        }
      }
    );
  }
}