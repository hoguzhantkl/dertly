import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dertly/models/entry_model.dart';
import 'package:dertly/services/auth_service.dart';
import 'package:dertly/services/entry_service.dart';

import '../locator.dart';

class CreateEntryViewModel {
  EntryService entryService = locator<EntryService>();
  AuthService authService = locator<AuthService>();

  Future<void> createEntry(EntryModel entryModel) async {
    await entryService.createEntry(entryModel);
  }

  // Note: This creating entry func doesn't record an audio to entry.
  Future<dynamic> createTestEntry() async {
    var userID = await authService.getCurrentUserUID();
    var contentUrl = "";

    EntryModel entryModel = EntryModel(entryID: "", userID: userID, title: "Test Title", contentAudioUrl: contentUrl, date: Timestamp.now(), upVote: 3, downVote: 0, totalAnswers: 0);
    return await entryService.createEntry(entryModel);
  }
}