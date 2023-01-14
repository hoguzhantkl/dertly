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

  Future<List<QueryDocumentSnapshot>?> fetchFirstTrendEntriesDocuments() async{
    var trendEntriesDocuments = await feedsService.fetchTrendEntriesDocuments(limited: true, atCursor: false);
    return trendEntriesDocuments;
  }

  Future<List<QueryDocumentSnapshot>?> fetchNextTrendEntriesDocuments() async{
    var trendEntriesDocuments = await feedsService.fetchTrendEntriesDocuments(limited: true, atCursor: true);
    return trendEntriesDocuments;
  }

  Future<List<QueryDocumentSnapshot>?> fetchTrendEntriesDocumentsBetweenPages({List<int> betweenPages = const [0, 1]}) async{
    var trendEntriesDocuments = await feedsService.fetchTrendEntriesDocumentsBetweenPages(betweenPages);
    return trendEntriesDocuments;
  }
}