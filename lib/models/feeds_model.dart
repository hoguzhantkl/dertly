import 'dart:collection';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'answer_model.dart';
import 'entry_model.dart';

enum EntryCategory { trendings, recents, yourturn, follower }

class WaveNoOfSamples {
  static const int entry = 45;
  static const int answer = entry; // Answer to Entry
  static const int subAnswer = 38; // Answer to an Answer(which is for an Entry)
  static const int mentionedSubAnswer = 30; // Answer to a Sub-Answer

  // No of Samples for answer
  static int getNoOfSamplesFromAnswerType(AnswerType answerType) {
    switch (answerType) {
      case AnswerType.subAnswer:
        return subAnswer;
      case AnswerType.mentionedSubAnswer:
        return mentionedSubAnswer;
      default:
        return answer;
    }
  }
}

class FeedsModel{
  LinkedHashMap<String, EntryModel> trendEntriesMap = LinkedHashMap.of({});
  int totalTrendEntriesCount = 0;

  List<String> recentEntriesIDList = [];
  LinkedHashMap<String, EntryModel> recentEntriesMap = LinkedHashMap.of({});

  bool isBottomSheetVisible = false;
  ValueNotifier<bool> onBottomSheetUpdate = ValueNotifier<bool>(false);

  Map<String, PlayerController> entryPlayerControllerMap = {}; // <entryID, ...>

  String currentListeningEntryID = "";
  EntryCategory currentListeningEntryCategory = EntryCategory.recents; // TODO: Change this to category where user is currently listening to an entry

  final pageSize = 20;
  DocumentSnapshot? lastVisibleTrendEntryDocumentSnapshot;

  void clear(){
    debugPrint('FeedsViewModel: Cleared all data');
    clearTrendEntries();
    clearRecentEntries();
  }

  void clearTrendEntries(){
    trendEntriesMap = LinkedHashMap.of({});
    lastVisibleTrendEntryDocumentSnapshot = null;
    debugPrint('FeedsViewModel: Cleared trend entries');
    debugPrint('FeedsViewModel: trendEntriesMap: $trendEntriesMap');
  }

  void clearRecentEntries(){
    recentEntriesIDList.clear();
    recentEntriesMap = LinkedHashMap.of({});
    debugPrint('FeedsViewModel: Cleared recent entries');
    debugPrint('FeedsViewModel: recentEntriesIDList: $recentEntriesIDList');
    debugPrint('FeedsViewModel: recentEntriesMap: $recentEntriesMap');
  }
}