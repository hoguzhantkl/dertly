import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dertly/services/auth_service.dart';

import '../locator.dart';
import '../models/entry_model.dart';

class EntryService{
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  AuthService authService = locator<AuthService>();

  Future<dynamic> createEntry(EntryModel entryModel) async{
    try {
      var entryCollectionRef = firestore.collection("entries");
      DocumentReference entryDocumentRef = entryCollectionRef.doc();
      DocumentSnapshot entryDocumentSnapshot = await entryDocumentRef.get();
      entryModel.entryID = entryDocumentSnapshot.reference.id;
      await entryDocumentSnapshot.reference.set(entryModel.toJson());
      return entryModel;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> fetchEntryData(String entryID) async{
    var entryCollectionRef = firestore.collection("entries");
    var entryDocRef = entryCollectionRef.doc(entryID);
    var entryDocSnapshot = await entryDocRef.get();
    if (entryDocSnapshot.exists){
      return entryDocSnapshot.data();
    }
    else{
      return null;
    }
  }
}