
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dertly/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:tuple/tuple.dart';

import '../locator.dart';

class FeedsService{
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  AuthService authService = locator<AuthService>();

  static const int trendEntriesPaginateLimit = 10;
  DocumentSnapshot? lastTrendEntryDocSnapshot; // TODO: we can change this to index based pagination instead of doc based pagination?

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
  Future<dynamic> fetchTrendEntriesDocuments({bool limited = true, bool atCursor = false}) async{
    var trendEntriesColRef = firestore.collection("feeds").doc("trendings").collection("list");
    if (limited){
      if (!atCursor){
        return await trendEntriesColRef.orderBy("score", descending: true).limit(trendEntriesPaginateLimit).get()
            .then((documentSnapshots) {
              if (documentSnapshots.docs.isNotEmpty) {
                lastTrendEntryDocSnapshot = documentSnapshots.docs[documentSnapshots.docs.length - 1];
              }
              return documentSnapshots.docs;
            });
      }
      else{
        if (lastTrendEntryDocSnapshot != null) {
          return await trendEntriesColRef
              .orderBy("score", descending: true)
              .startAfterDocument(lastTrendEntryDocSnapshot!)
              .limit(trendEntriesPaginateLimit)
              .get()
              .then((trendEntriesQuerySnapshot) {
                if (trendEntriesQuerySnapshot.docs.isNotEmpty) {
                  lastTrendEntryDocSnapshot = trendEntriesQuerySnapshot.docs.last;
                  return trendEntriesQuerySnapshot.docs;
                }
              });
        }
      }
    }
    else{
      return await trendEntriesColRef.orderBy("score", descending: true).get()
        .then((trendEntriesQuerySnapshot) {
          return trendEntriesQuerySnapshot.docs;
        });
    }

    return null;
  }

  Future<dynamic> fetchTrendEntriesDocumentsBetweenPages(List<int> betweenPages) async{
    var trendEntriesColRef = firestore.collection("feeds").doc("trendings").collection("list");
    final startIndex = betweenPages[0] * trendEntriesPaginateLimit;
    final endIndex = betweenPages[1] * trendEntriesPaginateLimit;
    return await trendEntriesColRef.orderBy("score", descending: true)
        .startAt([startIndex]).endAt([endIndex]).get()
        .then((documentSnapshots) {
          return documentSnapshots.docs;
        });
  }
}