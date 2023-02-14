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
  Future fetchTrendEntriesCount() async{
    var trendEntriesData = await feedsService.fetchTrendEntriesData();
    if (trendEntriesData != null){
      return trendEntriesData["totalTrendEntries"];
    }

    return null;
  }

  Future<List<QueryDocumentSnapshot>?> fetchAllTrendEntriesDocuments() async{
    var trendEntriesDocuments = await feedsService.fetchTrendEntriesDocuments();
    return trendEntriesDocuments;
  }

  Future<List<QueryDocumentSnapshot>?> fetchSomeTrendEntriesDocuments(DocumentSnapshot? lastVisibleDoc, int limit) async{
    var trendEntriesDocuments = await feedsService.fetchSomeTrendEntriesDocuments(lastVisibleDoc, limit);
    return trendEntriesDocuments;
  }
}