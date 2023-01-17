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
  @override
  void initState() {
    super.initState();
  }

  void onRefreshList() async {
    debugPrint("onRefreshList");
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
                  itemCount: feedsViewModel.model.recentEntriesMap.length,
                  itemBuilder: (context, index){
                    final entryID = feedsViewModel.model.recentEntriesMap.keys.elementAt(index);
                    final entryData = feedsViewModel.model.recentEntriesMap[entryID];
                    return EntriesListItem(entryModel: entryData!);},
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