import 'package:cloud_firestore/cloud_firestore.dart';

enum ReferenceType{
  entries,
  answers
}

enum VoteType{
  upVote,
  downVote
}

Map<String, int> totalVotesMap() {
  List<String> voteTypeList = VoteType.values.map((e) => e.name).toList();
  return Map.fromIterable(voteTypeList, value: (item) => 0);
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