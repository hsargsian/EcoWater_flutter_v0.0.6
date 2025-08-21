import 'package:echowater/core/domain/entities/protocol_routine_entity/protocol_routine_entity.dart';

class CustomizeProtocolEntity {
  CustomizeProtocolEntity({
    required this.id,
    required this.title,
    required this.category,
    required this.image,
    required this.isActive,
    required this.isTemplate,
    required this.routines,
    this.protocol,
  });

  final int id;
  final String title;
  final String category;
  final String image;
  final bool isActive;
  final bool isTemplate;
  final List<ProtocolRoutineEntity> routines;
  int? protocol;
}
