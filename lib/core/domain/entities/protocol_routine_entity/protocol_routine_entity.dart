class ProtocolRoutineEntity {
  ProtocolRoutineEntity({
    required this.day,
    required this.activeDay,
    required this.items,
    this.id,
  });

  int? id;
  final String day;
  bool activeDay;
  final List<RoutineItemEntity> items;
}

class RoutineItemEntity {
  RoutineItemEntity({
    required this.title,
    required this.startTime,
    required this.endTime,
    this.id,
  });

  final int? id;
  final String title;
  final String startTime;
  final String endTime;
}
