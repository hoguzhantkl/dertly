import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';

import '../../core/themes/custom_colors.dart';

class AudioWave extends StatefulWidget{
  const AudioWave({super.key, required this.playerController, required this.audioDuration, this.audioWaveData = const [], this.width = 270, this.height = 30});

  final PlayerController playerController;
  final List<double> audioWaveData;
  final int audioDuration;

  final double width;
  final double height;

  @override
  State<AudioWave> createState() => AudioWaveState();
}

class AudioWaveState extends State<AudioWave>{
  @override
  Widget build(BuildContext context) {
    var maxDuration = Duration(milliseconds: widget.audioDuration);
    var maxDurationText = "${maxDuration.inMinutes.toString().padLeft(2, '0')}:${maxDuration.inSeconds.remainder(60).toString().padLeft(2, '0')}";
    return Column(
      children: [
        AudioFileWaveforms(
          size: Size(widget.width, widget.height),
          playerController: widget.playerController,
          enableSeekGesture: true,
          waveformType: WaveformType.fitWidth,
          waveformData: widget.audioWaveData,
          playerWaveStyle: const PlayerWaveStyle(
          liveWaveColor: CustomColors.green,
          spacing: 6,
          ),
        ),

        const SizedBox(height: 6),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StreamBuilder(
              stream: widget.playerController.onCurrentDurationChanged,
              builder: (context, snapshot) {
                var currentDuration = snapshot.hasData ? Duration(milliseconds: snapshot.data as int) : Duration.zero;
                var inMinSec = "${currentDuration.inMinutes.toString().padLeft(2, '0')}:${currentDuration.inSeconds.remainder(60).toString().padLeft(2, '0')}";
                return Text(inMinSec, style: const TextStyle(fontSize: 12));
              },
            ),
            Text(
              maxDurationText,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),

      ],
    );
  }
}