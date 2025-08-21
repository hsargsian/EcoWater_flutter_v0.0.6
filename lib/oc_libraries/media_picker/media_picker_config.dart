import 'package:flutter/cupertino.dart';
import 'package:image_cropper/image_cropper.dart';

import 'media_picker_crop_settings.dart';

class MediaPickerConfig {
  MediaPickerConfig({
    this.cropsImage = true,
    this.compressQuality = 80,
    this.cropAspectRatio = const CropAspectRatio(ratioX: 2, ratioY: 3),
    this.mediaPickerCropSettings,
    this.textStyle,
  });
  bool cropsImage;
  final int compressQuality;
  final CropAspectRatio cropAspectRatio;
  final MediaPickerCropSettings? mediaPickerCropSettings;
  final TextStyle? textStyle;
}
