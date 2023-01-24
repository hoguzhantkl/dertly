import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:permission_handler/permission_handler.dart';

import '../locator.dart';
import '../models/answer_model.dart';
import '../models/entry_model.dart';
import '../models/feeds_model.dart';
import 'auth_service.dart';
import 'entry_service.dart';

class AudioService {
  final recorder = FlutterSoundRecorder();
  final player = AudioPlayer();

  final RecorderController recorderController = RecorderController();

        /*..androidEncoder = AndroidEncoder.aac
        ..androidOutputFormat = AndroidOutputFormat.aac_adts
        ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
        ..sampleRate = 44100;*/

  final PlayerController playerController = PlayerController();

  bool isRecorderReady = false;

  Future initialize() async {
    await initRecorder();
  }

  Future initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }

    /*recorder.openRecorder();

    isRecorderReady = true;

    recorder.setSubscriptionDuration(
      const Duration(milliseconds: 500),
    );*/
  }

  void dispose() async {
    await recorder.closeRecorder();

    recorderController.refresh();
    recorderController.dispose();

    playerController.dispose();
  }

  Future startRecord() async {
    if (!isRecorderReady) return;
    await recorder.startRecorder(toFile: 'audio.aac');
  }

  Future stopRecord() async {
    if (!isRecorderReady) return;

    final path = await recorder.stopRecorder();
    debugPrint('Recorded audio: $path');

    return path;
  }

  Future<List<double>> getPlayingWaveformData(String path, {int noOfSamples = 100}) async{
    final waveformData = await playerController.extractWaveformData(
        path: path,
        noOfSamples: noOfSamples
    );
    return waveformData;
  }

  Future startWaveRecord() async {
    if (recorderController.isRecording){
      debugPrint("Recorder is already active");
      return false;
    }

    await recorderController.record();
    return true;
  }

  bool isWaveRecording(){
    return recorderController.isRecording;
  }

  Future stopWaveRecord() async {
    final path = await recorderController.stop();
    return path;
  }

  Future cancelWaveRecord() async{
    await stopWaveRecord()
        .then((recordedAudioFileLocalUrl) {
          File audioFile = File(recordedAudioFileLocalUrl);
          audioFile.delete();
        })
        .catchError((error, stackTrace) {
          debugPrint("Error in cancelWaveRecord(): $error");
        });
  }
}