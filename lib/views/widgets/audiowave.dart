import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';

import '../../core/themes/custom_colors.dart';

class AudioWave extends StatefulWidget{
  const AudioWave({super.key, required this.playerController, this.audioWaveData = const [], this.width = 270, this.height = 30});

  final PlayerController playerController;
  final List<double> audioWaveData;

  final double width;
  final double height;

  @override
  State<AudioWave> createState() => AudioWaveState();
}

class AudioWaveState extends State<AudioWave>{
  @override
  Widget build(BuildContext context) {
    return AudioFileWaveforms(
      size: Size(widget.width, widget.height),
      playerController: widget.playerController,
      enableSeekGesture: true,
      waveformType: WaveformType.fitWidth,
      waveformData: widget.audioWaveData,
      playerWaveStyle: const PlayerWaveStyle(
        liveWaveColor: CustomColors.green,
        spacing: 6,
      ),
    );
  }
}