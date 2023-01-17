import 'dart:collection';
import 'dart:math';

import 'package:dertly/locator.dart';
import 'package:dertly/models/feeds_model.dart';
import 'package:dertly/repositories/entry_repository.dart';
import 'package:dertly/services/audio_service.dart';
import 'package:flutter/widgets.dart';

import '../models/entry_model.dart';

import '../repositories/feeds_repository.dart';
import '../services/entry_service.dart';

class FeedsViewModel extends ChangeNotifier{
  FeedsViewModel({required this.feedsRepository});
  final FeedsRepository feedsRepository;
  EntryRepository entryRepository = locator<EntryRepository>();

  FeedsModel model = FeedsModel();

  // Services
  EntryService entryService = locator<EntryService>();
  AudioService audioService = locator<AudioService>();

  void clearModelData(){
    model.clear();
  }

  // Recents
  Future fetchRecentEntryIDs() async{
    try{
      final recentEntriesIDList = await feedsRepository.fetchRecentEntriesIDList();
      if (recentEntriesIDList == null) {
        debugPrint("Could not fetch recent entries ID list, recentEntriesIDList is null");
      }
      else{
        model.recentEntriesIDList = recentEntriesIDList.cast<String>();
      }
    }catch(e){
      return Future.error(Exception(e));
    }
  }

  Future<void> fetchAllRecentEntries() async{
    try{
      await fetchRecentEntryIDs();
      for (var entryID in model.recentEntriesIDList){
        var entry = await entryRepository.fetchEntry(entryID);
        if (entry == null){
          debugPrint("Could not fetch entry data for entryID: $entryID");
        }
        else{
          model.recentEntriesMap[entryID] = entry;
          debugPrint("Fetched entry data for entryID: $entryID from data entryID ${model.recentEntriesMap[entryID]?.entryID}");
        }
      }
      notifyListeners();
    }catch(e){
      return Future.error(Exception(e));
    }
  }

  Future<void> fetchSomeRecentEntries(int startIndex, int endIndex) async{
    await fetchRecentEntryIDs();

    startIndex = max(0, min(startIndex, model.recentEntriesIDList.length));
    endIndex = min(model.recentEntriesIDList.length, endIndex);

    try{
      for (var i = startIndex; i <= endIndex; i++){
        var entryID = model.recentEntriesIDList[i];
        var entry = await entryRepository.fetchEntry(entryID);
        if (entry == null){
          debugPrint("Could not fetch entry data for entryID: $entryID");
        }
        else{
          model.recentEntriesMap[entryID] = entry;
          debugPrint("some, Fetched entry data for entryID: $entryID from data entryID ${model.recentEntriesMap[entryID]?.entryID}");
        }
      }
    }catch(e){
      return Future.error(Exception(e));
    }
  }

  // Trendings
  Future<dynamic> fetchAllTrendEntries() async{
    try{
      List<EntryModel> trendEntriesData = [];
      var trendEntriesDocuments = await feedsRepository.fetchAllTrendEntriesDocuments();
      if (trendEntriesDocuments != null){

        if (trendEntriesDocuments.isEmpty) {
          debugPrint("No trend entries found");
        }

        for (var trendEntryDoc in trendEntriesDocuments){
          var entryID = trendEntryDoc["entryID"];
          EntryModel? entry = await entryRepository.fetchEntry(entryID);
          if (entry == null){
            debugPrint("Could not fetch entry data for entryID: $entryID");
          }
          else{
            trendEntriesData.add(entry);
            debugPrint("trend, Fetched entry data for entryID: $entryID from data entryID ${entry.entryID}");
          }
        }
      }else{
        debugPrint("Could not fetch trend entries documents, trendEntriesDocuments is null");
        return null;
      }

      return trendEntriesData;

    }catch(e){
      return Future.error(Exception(e));
    }
  }

  void setEntryBottomSheetVisibility(bool isVisible){
    model.isEntryBottomSheetVisible = isVisible;
    notifyListeners();
  }

  // Signals from View
  Future onEntryListenButtonClicked(String? contentUrl) async{
    await entryService.listenEntryContentAudio(contentUrl)
        .catchError((onError){
      debugPrint(onError.toString());
    });

    if (!model.isEntryBottomSheetVisible){
      setEntryBottomSheetVisibility(true);
    }
  }

  Future onEntryCreateTestAnswerButtonClicked(String entryID) async{
    if (audioService.recorder.isRecording) {
      var recordedAudioFile = await audioService.stopRecord();
      audioService.createTestAnswerToEntry(entryID, recordedAudioFile);
    } else {
      await audioService.startRecord();
    }

  }
}