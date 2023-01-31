import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dertly/models/vote_model.dart';

class VoteService{
  Future giveVote(VoteModel voteModel) async{
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    try{
      var votesCollectionRef = firestore.collection("votes");
      DocumentReference voteDocumentRef = votesCollectionRef.doc();
      DocumentSnapshot voteDocumentSnapshot = await voteDocumentRef.get();
      voteModel.voteID = voteDocumentSnapshot.reference.id;

      await voteDocumentSnapshot.reference.set(voteModel.toJson());
      return voteModel;

    }catch(e){
      Future.error(Exception(e));
    }
  }
}