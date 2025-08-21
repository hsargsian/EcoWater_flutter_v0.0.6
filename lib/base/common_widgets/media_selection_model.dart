import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class MediaSelectionModel {
  MediaSelectionModel(
      {required this.id,
      required this.file,
      required this.isImage,
      this.isDummy = false});
  MediaSelectionModel.dummy()
      : id = const Uuid().v4(),
        file = null,
        isImage = true,
        isDummy = true;
  final String id;
  final XFile? file;
  final bool isImage;
  bool isDummy = false;
}
