import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../core/themes/custom_colors.dart';

class ImageService{
  var imagePicker = ImagePicker();
  var imageCropper = ImageCropper();

  // Image Picker
  Future<XFile?> pickImage(ImageSource source) async{
    return await imagePicker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        preferredCameraDevice: CameraDevice.front,
    );
  }

  Future<XFile?> pickImageFromGallery() async{
    return await pickImage(ImageSource.gallery);
  }

  Future<XFile?> pickImageFromCamera() async{
    return await pickImage(ImageSource.camera);
  }

  // Image Cropper
  Future<CroppedFile?> cropImage(String sourcePath) async{
    return await imageCropper.cropImage(
        sourcePath: sourcePath,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Crop Image',
              toolbarColor: Colors.black,
              toolbarWidgetColor: Colors.white,
              activeControlsWidgetColor: CustomColors.green,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false
          ),
          IOSUiSettings(
              title: 'Crop Image',
          )
        ]
    );
  }
}