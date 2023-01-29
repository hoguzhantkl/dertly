import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:dertly/models/user_model.dart';
import 'package:dertly/services/image_service.dart';
import 'package:image_cropper/image_cropper.dart';

import '../locator.dart';
import '../services/audio_service.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';

class CreateProfileViewModel{
  AuthService authService = locator<AuthService>();
  UserService userService = locator<UserService>();
  ImageService imageService = locator<ImageService>();
  AudioService audioService = locator<AudioService>();

  CroppedFile? pickedImageFile;
  String? recordedUsernameAudioFilePath;
  List<double> recordedUsernameAudioWaveData = List.of([]);
  int recordedUsernameAudioDuration = 0;

  Future<dynamic> pickUserImageFromGallery() async{
    var pickedImageFile = await imageService.pickImageFromGallery();
    if (pickedImageFile != null){
      var croppedImageFile = await imageService.cropImage(pickedImageFile.path);
      if (croppedImageFile != null){
        this.pickedImageFile = croppedImageFile;
        // TODO: upload image to firebase storage
      }
    }

    return pickedImageFile;
  }

  void deletePickedImage(){
    pickedImageFile = null;
  }

  Future<void> stopUsernameAudioRecording() async{
    recordedUsernameAudioFilePath = await audioService.stopWaveRecord();
    if (recordedUsernameAudioFilePath != null){
      recordedUsernameAudioWaveData = await audioService.getPlayingWaveformData(recordedUsernameAudioFilePath!, noOfSamples: 46);
      recordedUsernameAudioDuration = await audioService.getAudioDuration(recordedUsernameAudioFilePath!);
    }
    await stopUsernameAudio();
  }

  Future<void> listenUsernameAudio() async{
    if (recordedUsernameAudioFilePath != null){

      var playerState = audioService.playerController.playerState;
      if (playerState.isPlaying) {
        await pauseUsernameAudio();
      }
      else if(playerState.isPaused){
        await playUsernameAudio();
      }
      else
      {
        await audioService.playerController.preparePlayer(
            path: recordedUsernameAudioFilePath!,
            noOfSamples: 46,
            volume: 1.0
        );

        await playUsernameAudio();
      }
    }
  }

  Future<void> playUsernameAudio() async{
    await audioService.playerController.startPlayer(finishMode: FinishMode.pause);
  }

  Future<void> pauseUsernameAudio() async{
    await audioService.playerController.pausePlayer();
  }

  Future<void> stopUsernameAudio() async{
    if (!audioService.playerController.playerState.isStopped){
      await audioService.playerController.stopPlayer();
    }
  }

  void deleteRecordedUsernameAudioFile(){
    recordedUsernameAudioFilePath = null;
    recordedUsernameAudioWaveData = List.of([]);
    recordedUsernameAudioDuration = 0;
  }

  Future<void> createUserProfile() async{
    var userID = authService.getCurrentUserUID();
    UserModel userModel = UserModel(userID: userID);
    await userService.createUserData(userModel);
  }
}