import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:permission_handler/permission_handler.dart';

class RecorderScreen extends StatefulWidget {
  const RecorderScreen({super.key});

  @override
  State<RecorderScreen> createState() => _RecorderScreenState();
}

class _RecorderScreenState extends State<RecorderScreen>{
  final recorder = FlutterSoundRecorder();
  final audioPlayer = AudioPlayer();

  bool isRecorderReady = false;

  @override
  void initState() {
    super.initState();
    initRecorder();
  }

  @override
  void dispose() {
    recorder.closeRecorder();
    super.dispose();
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

  Future record() async {
    if (!isRecorderReady) return;
    await recorder.startRecorder(toFile: 'audio.aac');
  }

  Future stop() async {
    if (!isRecorderReady) return;

    final path = await recorder.stopRecorder();
    final audioFile = File(path!);
    print('Recorded audio: $path');

    //await audioPlayer.setSourceAsset("sounds/Evillaugh.mp3");
    await audioPlayer.setSource(DeviceFileSource(path));
    await audioPlayer.resume();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recorder'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            StreamBuilder(
              stream: recorder.onProgress,
              builder: (context, snapshot) {
                final duration = snapshot.hasData ? snapshot.data!.duration : Duration.zero;

                String twoDigits(int n) => n.toString().padLeft(2, '0');
                String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
                String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

                return Text(
                    '$twoDigitMinutes:$twoDigitSeconds',
                    style: const TextStyle(
                        fontSize: 80,
                        fontWeight: FontWeight.bold
                    )
                );
              }
            ),
            ElevatedButton(
              child: Icon(
                  recorder.isRecording ? Icons.stop : Icons.mic,
                  size: 80
              ),
              onPressed: () async {
                if (recorder.isRecording) {
                  await stop();
                } else {
                  await record();
                }
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}