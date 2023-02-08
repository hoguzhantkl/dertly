import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dertly/locator.dart';
import 'package:dertly/repositories/entry_repository.dart';
import 'package:dertly/services/feeds_service.dart';

class FeedsRepository{
  FeedsService feedsService = locator<FeedsService>();
  EntryRepository entryRepository = locator<EntryRepository>();

  // Recents
  Future fetchRecentEntriesIDList() async{
    var recentEntriesData = await feedsService.fetchRecentEntriesData();
    if (recentEntriesData != null){
      return recentEntriesData["recentEntriesIDList"];
    }

    return null;
  }

  // Trendings
  Future<List<QueryDocumentSnapshot>?> fetchAllTrendEntriesDocuments() async{
    var trendEntriesDocuments = await feedsService.fetchTrendEntriesDocuments(limited: false);
    return trendEntriesDocuments;
  }

  Future<List<QueryDocumentSnapshot>?> fetchSomeTrendEntriesDocuments(int startIndex, int limit) async{
    var trendEntriesDocuments = await feedsService.fetchSomeTrendEntriesDocuments(startIndex, limit);
    return trendEntriesDocuments;
  }
}