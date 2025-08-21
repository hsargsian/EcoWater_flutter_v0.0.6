class EventEntity {
  EventEntity({
    required this.id,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.repeat,
  });

  int? id;
  final String title;
  final DateTime startTime;
  final DateTime endTime;
  final String repeat;
}
