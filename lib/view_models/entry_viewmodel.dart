import 'dart:collection';
import 'dart:io';

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
import '../repositories/answers_repository.dart';
import '../services/audio_service.dart';
import '../services/auth_service.dart';

class EntryViewModel extends ChangeNotifier{
  EntryViewModel({required this.entryRepository});

  final EntryRepository entryRepository;
  final AnswersRepository answersRepository = locator<AnswersRepository>();

  EntryModel? model; // currentListeningEntryModel
  List<AnswerModel> answers = List.of([]); // <answerID, answerModel>
  LinkedHashMap<String, List<AnswerModel>> subAnswersMap = LinkedHashMap.of({}); // <mentionedAnswerID, List<AnswerModel>>

  String? currentListeningAnswerID;

  // Services
  EntryService entryService = locator<EntryService>();
  AnswersService answersService = locator<AnswersService>();
  AuthService authService = locator<AuthService>();
  AudioService audioService = locator<AudioService>();

  void init(){
    answers = List.of([]);
    subAnswersMap = LinkedHashMap.of({});
  }

  void setEntryModel(EntryModel? entryModel){
    init();
    model = entryModel;
  }

  Future createMainAnswer(String entryID, AnswerType answerType) async{
    await createAnswer(entryID, answerType, "", "");
  }

  Future createSubAnswer(String entryID, String mentionedAnswerID) async{
    await createAnswer(entryID, AnswerType.subAnswer, mentionedAnswerID, "");
  }

  Future createMentionedSubAnswer(String entryID, String mentionedAnswerID, String mentionedUserID) async{
    await createAnswer(entryID, AnswerType.subAnswer, mentionedAnswerID, mentionedUserID);
  }

  Future<void> createAnswer(String entryID, AnswerType answerType, String mentionedAnswerID, String mentionedUserID) async {
    if (audioService.recorderController.isRecording){
      await audioService.stopWaveRecord()
          .then((recordedAudioFileLocalUrl) async{

            debugPrint("waveRecord stopped, isWaveRecording: ${audioService.isWaveRecording()}");

            var userID = authService.getCurrentUserUID();

            final audioWaveformData = await audioService.getPlayingWaveformData(recordedAudioFileLocalUrl!, noOfSamples: WaveNoOfSamples.answer);

            AnswerModel answerModel = AnswerModel(
                entryID: entryID, userID: userID,
                answerID: "", mentionedAnswerID: "", mentionedUserID: "",
                audioUrl: recordedAudioFileLocalUrl, audioWaveData: audioWaveformData, answerType: answerType,
                date: Timestamp.now(), upVote: 3, downVote: 0);

            await answersService.createAnswer(answerModel);
          })
          .onError((error, stackTrace) {
            debugPrint("Error while creating answer: $error");
          });
    }
  }

  Future<void> fetchAllEntryAnswers() async{
    try{
      if (model == null){
        debugPrint("Could not fetched main answers, model is null");
        return;
      }

      final answersList = await answersRepository.fetchAllMainAnswers(model!.entryID);
      if (answersList == null) {
        debugPrint("Could not fetch answers list, answersList is null");
        return;
      }

      answers = answersList;

    }catch(e){
      return Future.error(Exception(e));
    }
  }

  // This method fetches sub-answers only for the mentionedAnswerID
  Future<void> fetchAllSubAnswers(String mentionedAnswerID) async{
    try{
      if (model == null){
        debugPrint("Could not fetched sub answers, model is null");
        return;
      }

      final subAnswersList = await answersRepository.fetchAllSubAnswers(model!.entryID, mentionedAnswerID);
      if (subAnswersList == null) {
        debugPrint("Could not fetch sub answers list, answersList is null");
        return;
      }

      subAnswersMap[mentionedAnswerID] = subAnswersList;

    }catch(e){
      return Future.error(Exception(e));
    }
  }

  Future listenAnswer(String? answerID, String? audioUrl, PlayerController playerController) async{
    // TODO: create a .then() where we call listenAnswer() in view and call updateBottomSheetView() in feeds_viewmodel
    return await entryService.listenEntryAnswerAudio(audioUrl, playerController)
        .then((audioStorageUrl) {
          if (audioStorageUrl != null){
            setCurrentListeningAnswerID(answerID);
            return true;
          }

          return false;
        })
        .catchError((onError){
          debugPrint(onError.toString());
        });
  }

  void setCurrentListeningAnswerID(String? answerID) async{
    currentListeningAnswerID = answerID;
  }
}