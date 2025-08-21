class Asset {
  Asset({required this.id, required this.url, this.isImage = true});
  final String? id;
  final String url;
  bool isImage = true;
}
