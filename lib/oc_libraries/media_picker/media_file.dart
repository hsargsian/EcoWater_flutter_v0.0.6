import 'package:image_picker/image_picker.dart';

import 'media_type.dart';

class MediaFile {
  MediaFile(this.file, this.type);
  final XFile file;
  final MediaType type;
}
