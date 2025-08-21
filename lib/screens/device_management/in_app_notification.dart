class InAppNotification {
  InAppNotification(this.title, this.message, this.payload);
  final String? title;
  final String? message;
  final Map<String, dynamic> payload;
  String get notificationTitle {
    return title ?? 'title';
  }

  String get notificationBody {
    return message ?? '';
  }
}
