import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dertly/locator.dart';
import 'package:dertly/models/entry_model.dart';
import 'package:dertly/services/entry_service.dart';
import 'package:flutter/cupertino.dart';

class EntryRepository{
  EntryService entryService = locator<EntryService>();

  Future fetchEntry(String entryID) async{
    var entryData = await entryService.fetchEntryData(entryID);
    if (entryData != null){
      return EntryModel.fromMap(entryData);
    }

    return null;
  }

  List<EntryModel>? getEntryModelsFromDocuments(var entryDocuments){
    if (entryDocuments != null){
      List<EntryModel> entryModels = [];
      for (var entryDocument in entryDocuments){
        var entryData = entryDocument.data();
        entryModels.add(EntryModel.fromMap(entryData));
      }

      return entryModels;
    }

    return null;
  }

  Future fetchSomeUserEntryDocuments(String userID, DocumentSnapshot? lastVisibleDoc, int limit) async {
    debugPrint("entryRepo - fetchSomeUserEntryDocuments, userID: $userID, lastVisibleDoc data: ${lastVisibleDoc?.data()}, limit: $limit");
    var entryDocuments = await entryService.fetchSomeUserEntryDocuments(userID, lastVisibleDoc, limit);
    debugPrint("entryRepo - entryDocuments: $entryDocuments");
    return entryDocuments;
  }
  
}