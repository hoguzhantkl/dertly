import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'answer_model.dart';
import 'entry_model.dart';

enum EntryCategory { trendings, recents, yourturn, follower }

class WaveNoOfSamples {
  static const int entry = 45;
  static const int answer = entry; // Answer to Entry
  static const int subAnswer = 45; // Answer to an Answer(which is for an Entry)
  static const int mentionedAnswer = 45; // Answer to a Sub-Answer
}

class FeedsModel{
  List<String> recentEntriesIDList = [];
  LinkedHashMap<String, EntryModel> recentEntriesMap = LinkedHashMap.of({});

  bool isBottomSheetVisible = false;
  ValueNotifier<bool> onBottomSheetUpdate = ValueNotifier<bool>(false);

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