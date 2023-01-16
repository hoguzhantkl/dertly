import 'package:cloud_firestore/cloud_firestore.dart';

class EntryModel{
  String entryID;
  final String userID;
  final String title;
  String contentAudioUrl;
  final Timestamp date;
  final int upVote;
  final int downVote;
  final int totalAnswers;

  EntryModel({
      required this.entryID, required this.userID, required this.title, required this.contentAudioUrl,
      required this.date, required this.upVote, required this.downVote, required this.totalAnswers
  });

  factory EntryModel.fromMap(Map<String, dynamic> data) {
    return EntryModel(
      entryID: data['entryID'],
      userID: data['userID'],
      title: data['title'],
      contentAudioUrl: data['contentUrl'],
      date: data['date'],
      upVote: data['upVote'],
      downVote: data['downVote'],
      totalAnswers: data['totalAnswers']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'entryID': entryID,
      'userID': userID,
      'title': title,
      'contentUrl': contentAudioUrl,
      'date': date,
      'upVote': upVote,
      'downVote': downVote,
      'totalAnswers': totalAnswers
    };
  }
}