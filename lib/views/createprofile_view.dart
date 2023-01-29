import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:dertly/core/themes/custom_colors.dart';
import 'package:dertly/services/audio_service.dart';
import 'package:dertly/view_models/createprofile_viewmodel.dart';
import 'package:dertly/view_models/user_viewmodel.dart';
import 'package:dertly/views/widgets/audiowave.dart';
import 'package:dertly/views/widgets/recordaudiobutton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/routes/router.dart' as router;
import '../locator.dart';

class CreateProfileScreen extends StatefulWidget{
  const CreateProfileScreen({Key? key}) : super(key: key);

  @override
  State<CreateProfileScreen> createState() => CreateProfileScreenState();
}

class CreateProfileScreenState extends State<CreateProfileScreen>{
  late CreateProfileViewModel createProfileViewModel;

  @override
  void initState(){
    createProfileViewModel = CreateProfileViewModel();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //debugPrint("no of sample for the size: ${const PlayerWaveStyle(spacing: 6).getSamplesForWidth(280)}");
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            const Text(
              "Create your Profile",
              style: TextStyle(fontSize: 24, color: CustomColors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: createProfileViewModel.pickedImageFile != null
                        ? Image.file(
                            File(createProfileViewModel.pickedImageFile!.path),
                            width: 300,
                            height: 300,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/images/placeholder_pp.png',
                            width: 300,
                            height: 300,
                            fit: BoxFit.cover,
                          )
                  ),
                ),

                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: CustomColors.green,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: IconButton(
                          onPressed: () async{
                            await createProfileViewModel.pickUserImageFromGallery();
                            setState(() {

                            });
                          },
                          padding: const EdgeInsets.all(0),
                          icon: const Icon(
                              Icons.add_a_photo, color: CustomColors.white, size: 30
                          ),
                        ),
                      ),
                      Visibility(
                          visible: createProfileViewModel.pickedImageFile != null,
                          child: Container(
                            margin: const EdgeInsets.only(left: 10),
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: IconButton(
                              onPressed: () async{
                                createProfileViewModel.deletePickedImage();
                                setState(() {

                                });
                              },
                              padding: const EdgeInsets.all(0),
                              icon: const Icon(
                                  Icons.add_a_photo, color: CustomColors.white, size: 30
                              ),
                            ),
                          )
                      ),

                    ]
                  )
                ),
              ]
            ),
            const SizedBox(height: 30),

            Visibility(
              visible: createProfileViewModel.recordedUsernameAudioFilePath == null,
              child: Column(
                children: [
                  AudioWaveforms(
                    size: const Size(280, 30),
                    recorderController: locator<AudioService>().recorderController,
                    enableGesture: true,
                    waveStyle: WaveStyle(
                      waveColor: CustomColors.beige,
                      spacing: 8.0,
                      showMiddleLine: false,
                      extendWaveform: true,
                      backgroundColor: Colors.green,
                      showDurationLabel: false,
                      durationLinesColor: Colors.white,
                      durationStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  RecordAudioButton(
                      onRecordingFinishedCallback: () async{
                        await createProfileViewModel.stopUsernameAudioRecording();
                        setState(() {});
                      },
                      heroTag: "recordUsernameAudio"
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    "Record your username",
                    style: TextStyle(fontSize: 16, color: CustomColors.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              )
            ),

            Visibility(
              visible: createProfileViewModel.recordedUsernameAudioFilePath != null,
              child: Column(
                children: [
                  SizedBox(
                    width: 280,
                    height: 60,
                    child: AudioWave(
                      width: 280,
                      height: 30,
                      playerController: locator<AudioService>().playerController,
                      audioWaveData: createProfileViewModel.recordedUsernameAudioWaveData,
                      audioDuration: createProfileViewModel.recordedUsernameAudioDuration,
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      StreamBuilder(
                          stream: locator<AudioService>().playerController.onPlayerStateChanged,
                          builder: (context, snapshot){
                            final PlayerState playerState = (snapshot.hasData) ? snapshot.data! : PlayerState.stopped;

                            return IconButton(
                                onPressed: () async
                                {
                                  await createProfileViewModel.listenUsernameAudio();
                                },
                                icon: Icon(playerState.isPlaying ? Icons.pause : Icons.play_arrow, size: 42)
                            );
                          }
                      ),

                      IconButton(
                          onPressed: ()
                          {
                            createProfileViewModel.deleteRecordedUsernameAudioFile();
                            setState(() {});
                          },
                          icon: const Icon(Icons.delete, color: Colors.red, size: 42)
                      )
                    ]
                  )
                ],
              )
            ),

            const SizedBox(height: 30),
            
            ElevatedButton(
              style: Theme.of(context).elevatedButtonTheme.style,
              onPressed: () {
                createProfileViewModel.createUserProfile().then((value) =>
                    Provider.of<UserViewModel>(context, listen: false).fetchUserData()
                        .then((value) => locator<router.Router>().navigateHomeScreen())
                );
              },
              child: const Text('Create Profile'),
            ),
          ],
        ),
      ),
    );
  }
}