import 'package:image_picker/image_picker.dart';

enum MediaSource {
  gallery,
  camera,
  files;

  String get sourceTitle {
    switch (this) {
      case MediaSource.gallery:
        return 'Gallery';
      case MediaSource.camera:
        return 'Camera';
      case MediaSource.files:
        return 'File Browser';
    }
  }

  ImageSource get source {
    switch (this) {
      case MediaSource.gallery:
        return ImageSource.gallery;
      case MediaSource.camera:
        return ImageSource.camera;
      case MediaSource.files:
        return ImageSource.gallery;
    }
  }
}
