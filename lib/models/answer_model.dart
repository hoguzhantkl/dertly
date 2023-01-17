import 'package:cloud_firestore/cloud_firestore.dart';

enum AnswerType{
  support,
  neutral,
  opposite // TODO: find a better name
}

class AnswerModel{
  final String entryID;
  String answerID;
  final String userID;
  final String mentionedAnswerID;
  String answerAudioUrl;
  final AnswerType answerType;
  final Timestamp date;
  final int upVote;
  final int downVote;

  AnswerModel({
    required this.entryID, required this.answerID, required this.userID,
    this.mentionedAnswerID = '', required this.answerAudioUrl, required this.answerType,
    required this.date, required this.upVote, required this.downVote
  });

  factory AnswerModel.fromMap(Map<String, dynamic> data){
    return AnswerModel(
      entryID: data['entryID'],
      answerID: data['answerID'],
      userID: data['userID'],
      mentionedAnswerID: data['mentionedAnswerID'],
      answerAudioUrl: data['answerAudioUrl'],
      answerType: AnswerType.values.byName(data['answerType']),
      date: data['date'],
      upVote: data['upVote'],
      downVote: data['downVote']
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'entryID': entryID,
      'answerID': answerID,
      'userID': userID,
      'mentionedAnswerID': mentionedAnswerID,
      'answerAudioUrl': answerAudioUrl,
      'answerType': answerType.name,
      'date': date,
      'upVote': upVote,
      'downVote': downVote,
    };
  }
}