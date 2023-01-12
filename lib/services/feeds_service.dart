import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dertly/services/auth_service.dart';

import '../locator.dart';

class FeedsService{
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  AuthService authService = locator<AuthService>();

  Future<dynamic> fetchRecentEntriesData() async{
    var feedsCollectionRef = firestore.collection("feeds");
    var recentEntriesDocRef = feedsCollectionRef.doc("recents");
    var recentEntriesDocSnapshot = await recentEntriesDocRef.get();
    if (recentEntriesDocSnapshot.exists){
      return recentEntriesDocSnapshot.data();
    }
    else{
      return null;
    }
  }
}