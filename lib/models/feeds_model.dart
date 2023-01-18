import 'dart:collection';

import 'package:flutter/cupertino.dart';

import 'answer_model.dart';
import 'entry_model.dart';

enum EntryCategory { trendings, recents, yourturn, follower }

class FeedsModel{
  List<String> recentEntriesIDList = [];
  LinkedHashMap<String, EntryModel> recentEntriesMap = LinkedHashMap.of({});

  bool isEntryBottomSheetVisible = false;

  String? currentListeningEntryID; // TODO: specify in which map(trends, recents, etc.) should we use this id.
  EntryCategory currentListeningEntryCategory = EntryCategory.recents;

  void clear(){
    recentEntriesIDList.clear();
    recentEntriesMap = LinkedHashMap.of({});
    debugPrint('FeedsViewModel: Cleared all data');
    debugPrint('FeedsViewModel: recentEntriesIDList: $recentEntriesIDList');
    debugPrint('FeedsViewModel: recentEntriesMap: $recentEntriesMap');
  }
}