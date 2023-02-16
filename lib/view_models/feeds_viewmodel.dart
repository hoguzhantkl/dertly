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
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

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

  Future fetchSomeRecentEntries(int pageKey, PagingController pagingController) async{
    await fetchRecentEntryIDs();

    try{

      var recentEntriesIDListLength = model.recentEntriesIDList.length;
      var startIndex = min(pageKey * model.pageSize, recentEntriesIDListLength - 1);
      var endIndex = min(startIndex + model.pageSize - 1, recentEntriesIDListLength - 1);

      debugPrint("fetchSomeRecentEntries, pageKey: $pageKey, startIndex: $startIndex, endIndex: $endIndex, recentEntriesIDListLength: $recentEntriesIDListLength");

      List<EntryModel> newRecentEntries = [];

      if (startIndex >= 0 && startIndex <= recentEntriesIDListLength && endIndex <= recentEntriesIDListLength){
        for (var i = startIndex; i <= endIndex; i++){
          var entryID = model.recentEntriesIDList[i];
          var entry = await entryRepository.fetchEntry(entryID);
          if (entry == null){
            debugPrint("Could not fetch entry data for entryID: $entryID");
          }
          else{
            model.recentEntriesMap[entryID] = entry;
            newRecentEntries.add(entry);
            debugPrint("some, Fetched entry data for entryID: $entryID from data entryID ${model.recentEntriesMap[entryID]?.entryID}");
          }
        }
      }

      final previouslyFetchedEntriesCount = pagingController.itemList?.length ?? 0;

      final isLastPage = model.recentEntriesIDList.length <= previouslyFetchedEntriesCount + newRecentEntries.length;

      if (isLastPage) {
        pagingController.appendLastPage(newRecentEntries);
      }
      else {
        final nextPageKey = pageKey + 1;
        pagingController.appendPage(newRecentEntries, nextPageKey);
      }

    }catch(e){
      pagingController.error = e;
      return Future.error(Exception(e));
    }
  }

  // Trendings
  Future fetchTrendEntriesCount() async{
    try{
      final totalTrendEntriesCount = await feedsRepository.fetchTrendEntriesCount();
      if (totalTrendEntriesCount == null) {
        debugPrint("Could not fetch trend entries count, totalTrendEntriesCount is null");
      }
      else{
        model.totalTrendEntriesCount = totalTrendEntriesCount;
      }
    }catch(e){
      return Future.error(Exception(e));
    }
  }

  Future fetchSomeTrendEntries(int pageKey, PagingController pagingController) async{
    await fetchTrendEntriesCount();

    try{
      if (pageKey == 0){
        model.clearTrendEntries();
      }

      List<EntryModel> newTrendEntries = [];

      var limit = model.pageSize;

      var trendEntriesDocuments = await feedsRepository.fetchSomeTrendEntriesDocuments(model.lastVisibleTrendEntryDocumentSnapshot, limit);
      if (trendEntriesDocuments != null){
        if (trendEntriesDocuments.isEmpty) {
          debugPrint("No trend entries found");
        }

        var trendEntriesDocumentsCount = trendEntriesDocuments.length;

        for (int i=0; i<trendEntriesDocumentsCount; i++){
          var trendEntryDoc = trendEntriesDocuments[i];
          var entryID = trendEntryDoc["entryID"];
          EntryModel? entry = await entryRepository.fetchEntry(entryID);
          if (entry == null){
            debugPrint("Could not fetch trend entry data for entryID: $entryID");
          }
          else{
            model.trendEntriesMap[entryID] = entry;
            newTrendEntries.add(entry);
            debugPrint("trend, Fetched entry data for entryID: $entryID from data entryID ${entry.entryID}");

            if (i == trendEntriesDocumentsCount - 1){
              model.lastVisibleTrendEntryDocumentSnapshot = trendEntryDoc;
            }
          }
        }

        final previouslyFetchedEntriesCount = pagingController.itemList?.length ?? 0;

        final isLastPage = model.totalTrendEntriesCount <= previouslyFetchedEntriesCount + newTrendEntries.length;

        if (isLastPage) {
          pagingController.appendLastPage(newTrendEntries);
        }
        else {
          final nextPageKey = pageKey + 1;
          pagingController.appendPage(newTrendEntries, nextPageKey);
        }

      }else{
        debugPrint("Could not fetch trend entries documents, trendEntriesDocuments is null");
        return null;
      }
    }catch(e){
      pagingController.error = e;
      debugPrint("Could not fetch some trend entries, error: $e");
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
    //disposeEntryPlayerController(entryID);

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
    debugPrint("Disposing entry player controller for entryID: $entryID");
    if (model.entryPlayerControllerMap.containsKey(entryID)){
      model.entryPlayerControllerMap[entryID]?.dispose();
      model.entryPlayerControllerMap.remove(entryID);
    }
  }

  Future listenEntry(String? entryID, EntryCategory? entryCategory, String? contentUrl, PlayerController playerController) async{
    return await entryService.listenEntryContentAudio(contentUrl, playerController)
        .then((audioStorageUrl) async {
            if (audioStorageUrl != null){
              await setCurrentListeningEntryID(entryID, entryCategory);
              return true;
            }
          })
        .catchError((onError){
          debugPrint(onError.toString());
        });
  }

  Future<void> setCurrentListeningEntryID(String? entryID, EntryCategory? entryCategory) async{
    if (model.currentListeningEntryID != entryID){
      await pauseCurrentListeningEntryAudio();
    }

    model.currentListeningEntryID = (entryID != null) ? entryID : "";
    if (entryCategory != null)
    {
      model.currentListeningEntryCategory = entryCategory;
    }

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
  Future fetchSomeEntriesForCategory(EntryCategory entryCategory, int pageKey, PagingController pagingController) async{
    switch(entryCategory){
      case EntryCategory.trendings:
        await fetchSomeTrendEntries(pageKey, pagingController)
          .catchError((onError) {
            debugPrint("Could not fetch some trend entries, error: ${onError.toString()}");
          });
        break;
      case EntryCategory.recents:
        await fetchSomeRecentEntries(pageKey, pagingController)
          .catchError((onError) {
            debugPrint("Could not fetch some recent entries, error: ${onError.toString()}");
          });
        break;
      default:
        break;
    }
  }

  LinkedHashMap<String, EntryModel> getEntriesMapForCategory(EntryCategory? entryCategory){
    switch(entryCategory){
      case EntryCategory.trendings:
        return model.trendEntriesMap;
      case EntryCategory.recents:
        return model.recentEntriesMap;
      default:
        return LinkedHashMap.of({});
    }
  }

  EntryModel? getEntryModel(String? entryID, EntryCategory? displayedEntryCategory){
    var entryMap = getEntriesMapForCategory(displayedEntryCategory);

    if (entryMap.containsKey(entryID)){
      return entryMap[entryID];
    }

    return null;
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