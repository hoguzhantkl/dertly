import 'dart:math';

import 'package:dertly/locator.dart';
import 'package:dertly/repositories/entry_repository.dart';
import 'package:flutter/widgets.dart';

import '../models/entry_model.dart';

import '../repositories/feeds_repository.dart';

class FeedsViewModel extends ChangeNotifier{
  FeedsViewModel({required this.feedsRepository});
  final FeedsRepository feedsRepository;
  EntryRepository entryRepository = locator<EntryRepository>();

  List<String> recentEntriesIDList = [];
  Map<String, EntryModel> recentEntriesMap = {};

  Future fetchRecentEntryIDs() async{
    try{
      final recentEntriesIDList = await feedsRepository.fetchRecentEntriesIDList();
      if (recentEntriesIDList == null) {
        debugPrint("Could not fetch recent entries ID list, recentEntriesIDList is null");
      }
      else{
        this.recentEntriesIDList = recentEntriesIDList.cast<String>();
      }
    }catch(e){
      return Future.error(Exception(e));
    }
  }

  Future fetchAllRecentEntries() async{
    try{
      await fetchRecentEntryIDs();
      for (var entryID in recentEntriesIDList){
        var entry = await entryRepository.fetchEntry(entryID);
        if (entry == null){
          debugPrint("Could not fetch entry data for entryID: $entryID");
        }
        else{
          recentEntriesMap[entryID] = entry;
          debugPrint("Fetched entry data for entryID: $entryID from data entryID ${recentEntriesMap[entryID]?.entryID}");
        }
      }
    }catch(e){
      return Future.error(Exception(e));
    }
  }

  Future<dynamic> fetchSomeRecentEntries(int startIndex, int endIndex) async{
    await fetchRecentEntryIDs();

    startIndex = max(0, min(startIndex, recentEntriesIDList.length));
    endIndex = min(recentEntriesIDList.length, endIndex);

    try{
      for (var i = startIndex; i <= endIndex; i++){
        var entryID = recentEntriesIDList[i];
        var entry = await entryRepository.fetchEntry(entryID);
        if (entry == null){
          debugPrint("Could not fetch entry data for entryID: $entryID");
        }
        else{
          recentEntriesMap[entryID] = entry;
          debugPrint("some, Fetched entry data for entryID: $entryID from data entryID ${recentEntriesMap[entryID]?.entryID}");
        }
      }
    }catch(e){
      return Future.error(Exception(e));
    }
  }

}