import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dertly/models/vote_model.dart';
import 'package:flutter/cupertino.dart';

/*
   if AnswerType is one of the following: support, neutral or suppose, then the answer called "main-answer" to an entry.
   otherwise it can be called "sub-answer" or "mentioned-sub-answer"
*/
enum AnswerType{
  support,
  neutral,
  opponent,
  subAnswer,
  mentionedSubAnswer
}

Map<String, int> totalAnswersMap() {
  List<String> answerTypeList = AnswerType.values.map((e) => e.name).toList();
  return Map.fromIterable(answerTypeList, value: (item) => 0);
}

/*
  if mentionedAnswerID is not empty, then this answer is a reply to another answer and called as "sub-answer".
     mentionedAnswerID is empty, then this answer is a reply to the entry and called as "main-answer".
  if mentionedUserID is not empty, then this answer is another user's answer and called as "mentioned-sub-answer" and is being listed in sub-answers.

  constraints:
    - mentionedAnswerID cannot be empty if mentionedUserID is not empty.

    example:
      mentionedAnswerID == "" && mentionedUserID == "" => OK (main-answer)
      mentionedAnswerID != "" && mentionedUserID == "" => OK (sub-answer)
      mentionedAnswerID != "" && mentionedUserID != "" => OK (mentioned-sub-answer)
      mentionedAnswerID == "" && mentionedUserID != "" => NOT OK
*/

class AnswerModel{
  final String entryID;
  final String userID;
  String answerID;
  final String mentionedAnswerID;
  final String mentionedUserID;
  String audioUrl;
  List<double>? audioWaveData;
  int audioDuration;
  final AnswerType answerType;
  final Timestamp date;
  final Map<String, int> totalVotes;

  AnswerModel({
    required this.entryID, required this.answerID, required this.userID,
    this.mentionedAnswerID = '', this.mentionedUserID = '',
    required this.audioUrl, required this.audioWaveData, required this.audioDuration,
    required this.answerType,
    required this.date, required this.totalVotes
  });

  factory AnswerModel.fromMap(Map<String, dynamic> data){
    return AnswerModel(
      entryID: data['entryID'],
      userID: data['userID'],
      answerID: data['answerID'],
      mentionedAnswerID: data['mentionedAnswerID'],
      mentionedUserID: data['mentionedUserID'],
      audioUrl: data['audioUrl'],
      audioWaveData: data['audioWaveData'].cast<double>(),
      audioDuration: data['audioDuration'],
      answerType: AnswerType.values.byName(data['answerType']),
      date: data['date'],
      totalVotes: data['totalVotes'].cast<String, int>(),
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'entryID': entryID,
      'userID': userID,
      'answerID': answerID,
      'mentionedAnswerID': mentionedAnswerID,
      'mentionedUserID': mentionedUserID,
      'audioUrl': audioUrl,
      'audioWaveData': audioWaveData,
      'audioDuration': audioDuration,
      'answerType': answerType.name,
      'date': date,
      'totalVotes': totalVotes
    };
  }

  bool isMainAnswer(){
    return mentionedAnswerID == '';
  }

  bool isSubAnswer(){
    return mentionedAnswerID != '' && mentionedUserID == '';
  }

  bool isMentionedSubAnswer(){
    return mentionedUserID != "";
  }

  int getTotalVotesCount(){
    return totalVotes.values.reduce((value, element) => value + element);
  }

  int getTotalUpVotesCount(){
    return totalVotes[VoteType.upVote.name] ?? 0;
  }

  int getTotalDownVotesCount(){
    return totalVotes[VoteType.downVote.name] ?? 0;
  }
}