import 'dart:collection';
import 'dart:math';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dertly/locator.dart';
import 'package:dertly/models/feeds_model.dart';
import 'package:dertly/repositories/entry_repository.dart';
import 'package:dertly/services/audio_service.dart';
import 'package:dertly/services/auth_service.dart';
import 'package:flutter/widgets.dart';

import '../models/answer_model.dart';
import '../models/entry_model.dart';

import '../models/vote_model.dart';
import '../repositories/feeds_repository.dart';
import '../services/entry_service.dart';

class FeedsViewModel extends ChangeNotifier{
  FeedsViewModel({required this.feedsRepository});
  final FeedsRepository feedsRepository;
  EntryRepository entryRepository = locator<EntryRepository>();

  FeedsModel model = FeedsModel();

  // Services
  AuthService authService = locator<AuthService>();
  EntryService entryService = locator<EntryService>();
  AudioService audioService = locator<AudioService>();

  void init(){
    clearModelData();
  }

  @override
  void dispose() {
    disposeAllEntryPlayerControllers();
    super.dispose();
  }

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
      debugPrint("Could not fetch all recent entries, error: $e");
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
      debugPrint("Could not fetch all trend entries, error: $e");
      return Future.error(Exception(e));
    }
  }

  // General Feed Methods
  Future<void> createEntry() async {
    if (audioService.recorderController.isRecording){

      await audioService.stopWaveRecord()
        .then((recordedAudioFileLocalUrl) async{
          var userID = authService.getCurrentUserUID();

          final audioWaveformData = await audioService.getPlayingWaveformData(recordedAudioFileLocalUrl!, noOfSamples: WaveNoOfSamples.entry);
          final audioDuration = await audioService.getAudioDuration(recordedAudioFileLocalUrl);

          debugPrint("creating entry with audioDuration: $audioDuration");

          debugPrint(audioWaveformData.toString());

          EntryModel entryModel = EntryModel(entryID: "", userID: userID, title: "Test Title",
              audioUrl: recordedAudioFileLocalUrl, audioWaveData: audioWaveformData, audioDuration: audioDuration,
              date: Timestamp.now(), totalVotes: totalVotesMap(), totalAnswers: totalAnswersMap());
          await entryService.createEntry(entryModel);
        });
    }
  }

  // Methods for listening to entry
  PlayerController createEntryPlayerController(String entryID){
    disposeEntryPlayerController(entryID);

    model.entryPlayerControllerMap[entryID] = PlayerController();

    return model.entryPlayerControllerMap[entryID]!;
  }

  PlayerController getEntryPlayerController(String entryID){
    final playerController = model.entryPlayerControllerMap[entryID];
    if (playerController == null){
      debugPrint("player controller notifier is null for entryID: $entryID");
      debugPrint("now creating new player controller notifier for entryID: $entryID");
      return createEntryPlayerController(entryID);
    }
    return playerController;
  }

  void disposeAllEntryPlayerControllers(){ 
    debugPrint("Disposing all entry player controllers");
    model.entryPlayerControllerMap.forEach((key, notifier) {
      notifier.dispose();
    });
    model.entryPlayerControllerMap.clear();
  }

  void disposeEntryPlayerController(String entryID){
    if (model.entryPlayerControllerMap.containsKey(entryID)){
      model.entryPlayerControllerMap[entryID]?.dispose();
      model.entryPlayerControllerMap.remove(entryID);
    }
  }

  Future listenEntry(String? entryID, String? contentUrl, PlayerController playerController) async{
    return await entryService.listenEntryContentAudio(contentUrl, playerController)
        .then((audioStorageUrl) async {
            if (audioStorageUrl != null){
              await setCurrentListeningEntryID(entryID);
              return true;
            }
          })
        .catchError((onError){
          debugPrint(onError.toString());
        });
  }

  Future<void> setCurrentListeningEntryID(String? entryID) async{
    if (model.currentListeningEntryID != entryID){
      await pauseCurrentListeningEntryAudio();
    }

    model.currentListeningEntryID = (entryID != null) ? entryID : "";

    var currentEntryModel = getCurrentListeningEntryModel();
    if (currentEntryModel != null){
      showBottomSheet();
    }
    else {
      hideBottomSheet();
    }
  }

  Future<void> clearCurrentListeningEntryID() async{
    await pauseCurrentListeningEntryAudio();

    model.currentListeningEntryID = "";
  }

  Future<void> pauseCurrentListeningEntryAudio() async{
    var currentListeningEntryModel = getCurrentListeningEntryModel();
    if (currentListeningEntryModel != null){
      var currentEntryPlayerController = model.entryPlayerControllerMap[currentListeningEntryModel.entryID];
      if (currentEntryPlayerController != null && currentEntryPlayerController.playerState.isPlaying) {
        await currentEntryPlayerController.pausePlayer();
      }
    }
  }

  // Methods for Entry Categorizing
  Future fetchEntriesForCategory(EntryCategory entryCategory) async{
    switch(entryCategory){
      case EntryCategory.recents:
        await fetchAllRecentEntries();
        break;
      default:
        break;
    }
  }

  LinkedHashMap<String, EntryModel> getEntriesMapForCategory(EntryCategory entryCategory){
    switch(entryCategory){
      case EntryCategory.recents:
        return model.recentEntriesMap;
      default:
        return LinkedHashMap.of({});
    }
  }

  EntryModel? getEntryModel(String? entryID, EntryCategory displayedEntryCategory){
    switch(displayedEntryCategory){
      case EntryCategory.recents:
        return model.recentEntriesMap[entryID];
      default:
        return null;
    }
  }

  EntryModel? getCurrentListeningEntryModel(){
    return getEntryModel(model.currentListeningEntryID, model.currentListeningEntryCategory);
  }

  // Methods for Bottom Sheet
  void setBottomSheetVisibility(bool isVisible){
    model.isBottomSheetVisible = isVisible;
  }

  void updateBottomSheetView(){
    model.onBottomSheetUpdate.value = !model.onBottomSheetUpdate.value;
  }

  void showBottomSheet(){
    setBottomSheetVisibility(true);
    updateBottomSheetView();
  }

  void hideBottomSheet(){
    setBottomSheetVisibility(false);
    updateBottomSheetView();
  }
}