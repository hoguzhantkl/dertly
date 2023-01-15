import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:permission_handler/permission_handler.dart';

import '../locator.dart';
import '../models/entry_model.dart';
import 'auth_service.dart';
import 'entry_service.dart';

class AudioService {
  final recorder = FlutterSoundRecorder();
  final player = AudioPlayer();

  bool isRecorderReady = false;

  Future initialize() async {
    await initRecorder();
  }

  Future initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }

    recorder.openRecorder();

    isRecorderReady = true;

    recorder.setSubscriptionDuration(
      const Duration(milliseconds: 500),
    );
  }

  void dispose() {
    recorder.closeRecorder();
  }

  Future startRecord() async {
    if (!isRecorderReady) return;
    await recorder.startRecorder(toFile: 'audio.aac');
  }

  Future stopRecord() async {
    if (!isRecorderReady) return;

    final path = await recorder.stopRecorder();
    final audioFile = File(path!);
    debugPrint('Recorded audio: $path');

    createTestEntry(path);
  }

  // NOTE: just for test purposes
  Future<void> createTestEntry(String? recordedContentVoiceLocalUrl) async {
    var authService = locator<AuthService>();
    var entryService = locator<EntryService>();

    var userID = await authService.getCurrentUserUID();

    EntryModel entryModel = EntryModel(entryID: "", userID: userID, title: "Test Title", contentUrl: recordedContentVoiceLocalUrl!, date: Timestamp.now(), upVote: 3, downVote: 0, totalAnswers: 0);
    await entryService.createEntry(entryModel);
  }


}