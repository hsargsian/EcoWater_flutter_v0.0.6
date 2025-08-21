import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

class MediaPickerCropSettings {
  MediaPickerCropSettings(
      {required this.toolbarWidgetColor,
      required this.activeControlsWidgetColor});
  final Color toolbarWidgetColor;
  final Color activeControlsWidgetColor;
  List<PlatformUiSettings> imageCropperSettings({
    required BuildContext context,
  }) {
    return [
      AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          statusBarColor: Theme.of(context).colorScheme.secondary,
          toolbarColor: Theme.of(context).colorScheme.secondary,
          toolbarWidgetColor: toolbarWidgetColor,
          activeControlsWidgetColor: activeControlsWidgetColor,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: true),
      IOSUiSettings(
        title: 'Crop Image',
        aspectRatioPickerButtonHidden: true,
        aspectRatioLockEnabled: true,
      )
    ];
  }
}
