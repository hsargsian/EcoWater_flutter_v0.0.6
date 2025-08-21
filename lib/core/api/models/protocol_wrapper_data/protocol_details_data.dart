import 'package:echowater/core/domain/entities/protocol_routine_entity/protocol_routine_entity.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../base/utils/images.dart';
import '../../../domain/entities/protocol_details_entity/protocol_details_entity.dart';

part 'protocol_details_data.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ProtocolDetailsData {
  ProtocolDetailsData(
      {required this.id,
      required this.title,
      required this.category,
      required this.image,
      required this.isTemplate,
      required this.education,
      required this.quotations,
      required this.routines,
      required this.isActive});

  factory ProtocolDetailsData.fromJson(Map<String, dynamic> json) => _$ProtocolDetailsDataFromJson(json);
  final int id;
  final String title;
  final String category;
  final String? image;
  final bool? isActive;
  final bool? isTemplate;
  final String? education;
  final List<Quotation>? quotations;
  final List<Routine> routines;

  Map<String, dynamic> toJson() => _$ProtocolDetailsDataToJson(this);

  ProtocolDetailsEntity asEntity() => ProtocolDetailsEntity(
        id: id,
        title: title,
        category: category,
        image: image ?? Images.defaultProtocolImage,
        isActive: isActive ?? false,
        isTemplate: isTemplate ?? false,
        education: education ?? '',
        quotations: quotations?.map((item) => item.asEntity()).toList() ?? [],
        routines: routines.map((item) => item.asEntity()).toList(),
      );
}

@JsonSerializable()
class Quotation {
  Quotation({required this.author, required this.testimony});

  factory Quotation.fromJson(Map<String, dynamic> json) => _$QuotationFromJson(json);
  final String author;
  final String testimony;

  Map<String, dynamic> toJson() => _$QuotationToJson(this);

  QuotationEntity asEntity() => QuotationEntity(author: author, testimony: testimony);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Routine {
  Routine({
    required this.day,
    required this.activeDay,
    required this.items,
    this.id,
  });

  factory Routine.fromJson(Map<String, dynamic> json) => _$RoutineFromJson(json);
  int? id;
  final String day;
  bool activeDay;
  final List<RoutineItem> items;

  Map<String, dynamic> toJson() => _$RoutineToJson(this);

  ProtocolRoutineEntity asEntity() =>
      ProtocolRoutineEntity(day: day, activeDay: activeDay, items: items.map((item) => item.asEntity()).toList());
}

@JsonSerializable(fieldRename: FieldRename.snake)
class RoutineItem {
  RoutineItem({
    required this.title,
    required this.startTime,
    required this.endTime,
    this.id,
  });

  factory RoutineItem.fromJson(Map<String, dynamic> json) => _$RoutineItemFromJson(json);
  final int? id;
  final String title;
  final String startTime;
  final String endTime;

  Map<String, dynamic> toJson() => _$RoutineItemToJson(this);

  RoutineItemEntity asEntity() => RoutineItemEntity(
        id: id,
        title: title,
        startTime: startTime,
        endTime: endTime,
      );
}
