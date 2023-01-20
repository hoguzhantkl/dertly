import 'package:flutter/material.dart';

class AudioWaveForm extends StatefulWidget{
  const AudioWaveForm({super.key});

  @override
  State<AudioWaveForm> createState() => AudioWaveFormState();
}

class AudioWaveFormState extends State<AudioWaveForm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(color: Colors.white10.withOpacity(0.03)),
    );
  }
}