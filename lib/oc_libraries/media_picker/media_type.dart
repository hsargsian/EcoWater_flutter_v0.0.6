enum MediaType {
  image,
  video,
  file;

  String get typeTitle {
    switch (this) {
      case MediaType.image:
        return 'Image';
      case MediaType.video:
        return 'Video';
      case MediaType.file:
        return 'File';
    }
  }
}
