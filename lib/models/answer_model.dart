import 'package:cloud_firestore/cloud_firestore.dart';

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
  String answerAudioUrl;
  List<double>? audioWaveData;
  final AnswerType answerType;
  final Timestamp date;
  final int upVote;
  final int downVote;

  AnswerModel({
    required this.entryID, required this.answerID, required this.userID,
    this.mentionedAnswerID = '', this.mentionedUserID = '',
    required this.answerAudioUrl, required this.audioWaveData, required this.answerType,
    required this.date, required this.upVote, required this.downVote
  });

  factory AnswerModel.fromMap(Map<String, dynamic> data){
    return AnswerModel(
      entryID: data['entryID'],
      userID: data['userID'],
      answerID: data['answerID'],
      mentionedAnswerID: data['mentionedAnswerID'],
      mentionedUserID: data['mentionedUserID'],
      answerAudioUrl: data['answerAudioUrl'],
      audioWaveData: data['audioWaveData'].cast<double>(),
      answerType: AnswerType.values.byName(data['answerType']),
      date: data['date'],
      upVote: data['upVote'],
      downVote: data['downVote']
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'entryID': entryID,
      'userID': userID,
      'answerID': answerID,
      'mentionedAnswerID': mentionedAnswerID,
      'mentionedUserID': mentionedUserID,
      'answerAudioUrl': answerAudioUrl,
      'audioWaveData': audioWaveData,
      'answerType': answerType.name,
      'date': date,
      'upVote': upVote,
      'downVote': downVote,
    };
  }
}