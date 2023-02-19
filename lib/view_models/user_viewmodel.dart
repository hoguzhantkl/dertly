import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dertly/models/user_temp_data_model.dart';
import 'package:dertly/repositories/entry_repository.dart';
import 'package:dertly/repositories/feeds_repository.dart';
import 'package:dertly/repositories/user_repository.dart';
import 'package:flutter/widgets.dart';

import 'package:dertly/models/user_model.dart';
import 'package:dertly/services/user_service.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../locator.dart';

class UserViewModel extends ChangeNotifier{
  UserViewModel({required this.userRepository, required this.userModel});

  final UserRepository userRepository;
  EntryRepository entryRepository = locator<EntryRepository>();

  UserModel userModel;
  UserTempDataModel userTempDataModel = UserTempDataModel();

  final pageSize = 10;
  DocumentSnapshot? lastVisibleEntryDocumentSnapshot;
  DocumentSnapshot? lastVisibleAnswerDocumentSnapshot;

  UserService userService = locator<UserService>();

  void setUserID(String userID){
    userModel.userID = userID;
  }

  Future<dynamic> fetchUserData() async{
    try{
      var userData = await userRepository.fetchUserData(userModel.userID);
      if (userData == null){
        return null;
      }
      userModel = userData;

      await fetchUserImage().catchError((onError){
        debugPrint("User image could not fetched: $onError");
      });
      await fetchUsernameAudio().catchError((onError){
        debugPrint("Username Audio could not fetched: $onError");
      });

      return userModel;
    }catch(e){
      return Future.error(Exception(e));
    }
  }

  Future<void> fetchUserImage() async{
    try{
      var userImageLocalPath = await userService.fetchUserImage(userModel!.imageUrl);
      userTempDataModel.profileImageFilePath = userImageLocalPath;
    }catch(e){
      return Future.error(Exception(e));
    }
  }

  Future<void> fetchUsernameAudio() async{
    try{
      var userAudioLocalPath = await userService.fetchUsernameAudio(userModel!.audioUrl);
      userTempDataModel.usernameAudioFilePath = userAudioLocalPath;
    }catch(e){
      return Future.error(Exception(e));
    }
  }

  Future<void> fetchSomeUserEntries(int pageKey, PagingController pagingController) async{
    try{
      if (pageKey == 0){
        lastVisibleEntryDocumentSnapshot = null;
      }

      debugPrint("fetchSomeEntries, pageKey: $pageKey, for userID: ${userModel.userID}");

      var limit = pageSize;

      final previouslyFetchedEntriesCount = pagingController.itemList?.length ?? 0;

      final newEntryDocs = await entryRepository.fetchSomeUserEntryDocuments(userModel.userID, lastVisibleEntryDocumentSnapshot, limit);
      final newEntry = entryRepository.getEntryModelsFromDocuments(newEntryDocs);
      if (newEntry == null) {
        debugPrint("Could not fetch user entries list, newEntry is null");
        return;
      }

      if (newEntryDocs.length > 0){
        lastVisibleEntryDocumentSnapshot = newEntryDocs[newEntryDocs.length - 1];
      }

      final isLastPage = userModel.getTotalUserEntriesCount() <= previouslyFetchedEntriesCount + newEntry.length;

      if (isLastPage) {
        pagingController.appendLastPage(newEntry);
      }
      else {
        final nextPageKey = pageKey + 1;
        pagingController.appendPage(newEntry, nextPageKey);
      }

      debugPrint("newEntry: ${newEntry.length} (pageKey: $pageKey)");

    }catch(e){
      pagingController.error = e;
      return Future.error(Exception(e));
    }
  }
}