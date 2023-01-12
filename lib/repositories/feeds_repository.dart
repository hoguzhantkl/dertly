import 'package:dertly/locator.dart';
import 'package:dertly/services/feeds_service.dart';

class FeedsRepository{
  FeedsService feedsService = locator<FeedsService>();

  Future fetchRecentEntriesIDList() async{
    var recentEntriesData = await feedsService.fetchRecentEntriesData();
    if (recentEntriesData != null){
      return recentEntriesData["recentEntriesIDList"];
    }

    return null;
  }
}