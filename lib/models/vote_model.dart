import 'package:cloud_firestore/cloud_firestore.dart';

enum ReferenceType{
  entry,
  answer
}

enum VoteType{
  upVote,
  downVote
}

class VoteModel{
  VoteModel({
    required this.voteID, required this.voteType, required this.userID,
    required this.referenceID, required this.referenceType, required this.date
  });

  String voteID;
  final VoteType voteType;
  final String userID;
  final String referenceID;
  final ReferenceType referenceType;
  final Timestamp date;

  factory VoteModel.fromMap(Map<String, dynamic> data){
    return VoteModel(
        voteID: data['voteID'],
        voteType: VoteType.values.byName(data['voteType']),
        userID: data['userID'],
        referenceID: data['referenceID'],
        referenceType: ReferenceType.values.byName(data['referenceType']),
        date: data['date']
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'voteID': voteID,
      'voteType': voteType.name,
      'userID': userID,
      'referenceID': referenceID,
      'referenceType': referenceType.name,
      'date': date
    };
  }
}