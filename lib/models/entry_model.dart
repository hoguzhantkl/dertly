import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dertly/models/vote_model.dart';

import 'answer_model.dart';

class EntryModel{
  String entryID;
  final String userID;
  final String title;
  String audioUrl;
  List<double>? audioWaveData;
  int audioDuration;
  final Timestamp date;
  final Map<String, int> totalVotes;
  final Map<String, int> totalAnswers;

  EntryModel({
      required this.entryID, required this.userID, required this.title,
      required this.audioUrl, required this.audioWaveData, required this.audioDuration,
      required this.date, required this.totalVotes, required this.totalAnswers
  });

  factory EntryModel.fromMap(Map<String, dynamic> data) {
    return EntryModel(
      entryID: data['entryID'],
      userID: data['userID'],
      title: data['title'],
      audioUrl: data['audioUrl'],
      audioWaveData: data['audioWaveData'].cast<double>(),
      audioDuration: data['audioDuration'],
      date: data['date'],
      totalVotes: data['totalVotes'].cast<String, int>(),
      totalAnswers: data['totalAnswers'].cast<String, int>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'entryID': entryID,
      'userID': userID,
      'title': title,
      'audioUrl': audioUrl,
      'audioWaveData': audioWaveData,
      'audioDuration': audioDuration,
      'date': date,
      'totalVotes': totalVotes,
      'totalAnswers': totalAnswers
    };
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

  int getTotalAnswersCount(){
    return totalAnswers.values.reduce((value, element) => value + element);
  }

  int getTotalMainAnswersCount(){
    return getTotalSupporterAnswersCount() + getTotalNeutralAnswersCount() + getTotalOpponentAnswersCount();
  }

  int getTotalSupporterAnswersCount(){
    return totalAnswers[AnswerType.support.name] ?? 0;
  }

  int getTotalNeutralAnswersCount(){
    return totalAnswers[AnswerType.neutral.name] ?? 0;
  }

  int getTotalOpponentAnswersCount(){
    return totalAnswers[AnswerType.opponent.name] ?? 0;
  }
}