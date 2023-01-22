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
  
}