import 'dart:collection';

import 'package:flutter/cupertino.dart';

import 'entry_model.dart';

class FeedsModel{
  List<String> recentEntriesIDList = [];
  LinkedHashMap<String, EntryModel> recentEntriesMap = LinkedHashMap.of({});

  bool isEntryBottomSheetVisible = false;

  void clear(){
    recentEntriesIDList.clear();
    recentEntriesMap = LinkedHashMap.of({});
    debugPrint('FeedsViewModel: Cleared all data');
    debugPrint('FeedsViewModel: recentEntriesIDList: $recentEntriesIDList');
    debugPrint('FeedsViewModel: recentEntriesMap: $recentEntriesMap');
  }
}