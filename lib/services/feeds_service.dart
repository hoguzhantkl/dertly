
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dertly/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:tuple/tuple.dart';

import '../locator.dart';

class FeedsService{
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  AuthService authService = locator<AuthService>();

  // Recents
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

  // Trendings
  Future<dynamic> fetchTrendEntriesData() async{
    var feedsCollectionRef = firestore.collection("feeds");
    var trendEntriesDocRef = feedsCollectionRef.doc("trendings");
    var trendEntriesDocSnapshot = await trendEntriesDocRef.get();
    if (trendEntriesDocSnapshot.exists){
      return trendEntriesDocSnapshot.data();
    }
    else{
      return null;
    }
  }

  Future<dynamic> fetchTrendEntriesDocuments() async{
    var trendEntriesColRef = firestore.collection("feeds").doc("trendings").collection("list");
    return await trendEntriesColRef.orderBy("score", descending: true).get()
        .then((trendEntriesQuerySnapshot) {
      return trendEntriesQuerySnapshot.docs;
    });
  }

  Future<dynamic> fetchSomeTrendEntriesDocuments(DocumentSnapshot? lastVisibleDoc, int limit) async{
    try{
      var trendEntriesColRef = firestore.collection("feeds").doc("trendings").collection("list");

      if (lastVisibleDoc == null){
        return await trendEntriesColRef.orderBy("score", descending: true).limit(limit).get()
            .then((documentSnapshots) {
          return documentSnapshots.docs;
        });
      }

      debugPrint("feedsService fetchSomeTrendEntries, lastVisibleDoc data: ${lastVisibleDoc.data()}");

      return await trendEntriesColRef.orderBy("score", descending: true).startAfterDocument(lastVisibleDoc).limit(limit).get()
          .then((documentSnapshots) {
            return documentSnapshots.docs;
          });
    }catch(e){
      return Future.error(Exception("Error while fetching some trend entries, error: $e"));
    }
  }
}