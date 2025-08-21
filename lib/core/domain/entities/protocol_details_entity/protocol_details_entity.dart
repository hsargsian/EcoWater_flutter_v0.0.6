import 'package:echowater/core/domain/entities/protocol_routine_entity/protocol_routine_entity.dart';

class ProtocolDetailsEntity {
  ProtocolDetailsEntity(
      {required this.id,
      required this.title,
      required this.category,
      required this.image,
      required this.isActive,
      required this.isTemplate,
      required this.education,
      required this.quotations,
      required this.routines});

  final int id;
  final String title;
  final String category;
  final String image;
  final bool isActive;
  final bool isTemplate;
  final String education;
  final List<QuotationEntity> quotations;
  final List<ProtocolRoutineEntity> routines;
}

class QuotationEntity {
  QuotationEntity({required this.author, required this.testimony});

  final String author;
  final String testimony;
}
