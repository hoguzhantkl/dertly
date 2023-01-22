import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dertly/repositories/entry_repository.dart';
import 'package:dertly/services/answers_service.dart';
import 'package:dertly/services/entry_service.dart';
import 'package:dertly/view_models/feeds_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../locator.dart';
import '../models/answer_model.dart';
import '../models/entry_model.dart';
import '../models/feeds_model.dart';
import '../services/audio_service.dart';
import '../services/auth_service.dart';

class EntryViewModel extends ChangeNotifier{
  EntryViewModel({required this.entryRepository});

  final EntryRepository entryRepository;

  EntryModel? model; // currentListeningEntryModel

  // Services
  EntryService entryService = locator<EntryService>();
  AnswersService answersService = locator<AnswersService>();
  AuthService authService = locator<AuthService>();
  AudioService audioService = locator<AudioService>();

  void setEntryModel(EntryModel? entryModel){
    model = entryModel;
  }

  Future startRecordingAnswer() async{
    await audioService.startWaveRecord();
  }

  Future createMainAnswer(String entryID, AnswerType answerType) async{
    createAnswer(entryID, answerType, "", "");
  }

  Future createSubAnswer(String entryID, String mentionedAnswerID) async{
    createAnswer(entryID, AnswerType.subAnswer, mentionedAnswerID, "");
  }

  Future createMentionedSubAnswer(String entryID, String mentionedAnswerID, String mentionedUserID) async{
    createAnswer(entryID, AnswerType.subAnswer, mentionedAnswerID, mentionedUserID);
  }

  Future<void> createAnswer(String entryID, AnswerType answerType, String mentionedAnswerID, String mentionedUserID) async {
    if (audioService.recorder.isRecording){
      await audioService.stopWaveRecord()
          .then((recordedAudioFileLocalUrl) async{
            var userID = authService.getCurrentUserUID();

            final audioWaveformData = await audioService.getPlayingWaveformData(recordedAudioFileLocalUrl!, noOfSamples: WaveNoOfSamples.answer);

            AnswerModel answerModel = AnswerModel(
                entryID: entryID, userID: userID,
                answerID: "", mentionedAnswerID: "", mentionedUserID: "",
                answerAudioUrl: recordedAudioFileLocalUrl, audioWaveData: audioWaveformData, answerType: answerType,
                date: Timestamp.now(), upVote: 3, downVote: 0);

            await answersService.createAnswer(answerModel);
          })
          .onError((error, stackTrace) {
            debugPrint("Error while creating answer: $error");
          });
    }
  }
}