import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dertly/locator.dart';
import 'package:dertly/services/entry_service.dart';
import 'package:dertly/services/storage_service.dart';
import 'package:flutter/material.dart';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:permission_handler/permission_handler.dart';

import '../models/entry_model.dart';
import '../services/audio_service.dart';
import '../services/auth_service.dart';

class RecorderScreen extends StatefulWidget {
  const RecorderScreen({super.key});

  @override
  State<RecorderScreen> createState() => _RecorderScreenState();
}

class _RecorderScreenState extends State<RecorderScreen>{
  var audioService = locator<AudioService>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
              stream: audioService.recorder.onProgress,
              builder: (context, snapshot) {
                final duration = (snapshot.hasData && !audioService.recorder.isStopped) ? snapshot.data!.duration : Duration.zero;

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
                  audioService.recorder.isRecording ? Icons.stop : Icons.mic,
                  size: 80
              ),
              onPressed: () async {
                if (audioService.recorder.isRecording) {
                  var recordedAudioFile = await audioService.stopRecord();
                  audioService.createTestEntry(recordedAudioFile);
                } else {
                  await audioService.startRecord();
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