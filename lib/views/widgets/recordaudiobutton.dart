import 'package:dertly/view_models/entry_viewmodel.dart';
import 'package:dertly/view_models/feeds_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:avatar_glow/avatar_glow.dart';

import '../../locator.dart';
import '../../services/audio_service.dart';

class RecordAudioButton extends StatefulWidget {
  const RecordAudioButton(
      {super.key,
      required this.onRecordingFinishedCallback,
      required this.heroTag,
      this.width = 60,
      this.height = 60});

  final AsyncCallback onRecordingFinishedCallback;
  final String heroTag;
  final double width;
  final double height;

  @override
  RecordAudioButtonState createState() => RecordAudioButtonState();
}

class RecordAudioButtonState extends State<RecordAudioButton> {
  bool lockHold = false;

  @override
  Widget build(BuildContext context) {
    AudioService audioService = locator<AudioService>();

    Future stopRecording() async {
      await widget.onRecordingFinishedCallback();
    }

    return GestureDetector(
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: FittedBox(
          child: FloatingActionButton(
            heroTag: widget.heroTag,
            onPressed: () async {
              if (lockHold) {
                debugPrint("Audio recording was locked and now finished");
                await stopRecording();
                setState(() {
                  lockHold = false;
                });
              }
            },
            backgroundColor: (audioService.isWaveRecording())
                ? ((lockHold)
                    ? Colors.amberAccent
                    : Theme.of(context).floatingActionButtonTheme.focusColor)
                : Theme.of(context).floatingActionButtonTheme.backgroundColor,
            child: const Icon(Icons.mic),
          ),
        ),
      ),
      onLongPressStart: (LongPressStartDetails details) async {
        await audioService.startWaveRecord().then((started) {
          if (started) {
            debugPrint("Audio recording has started");
            setState(() {});
          }
        });
      },
      onLongPressEnd: (LongPressEndDetails details) async {
        if (details.localPosition.dx < -30) {
          await audioService.cancelWaveRecord().then((value) {
            debugPrint("Audio recording has been canceled");
          });
          setState(() {});
          return;
        }

        if (details.localPosition.dy < -30) {
          debugPrint("Audio recording has been locked");
          setState(() {
            lockHold = true;
          });
          return;
        }

        await stopRecording().then((value) {
          debugPrint("Audio recording has been finished");
          setState(() {});
        });
      },
      onLongPressCancel: () {},
    );
  }
}
