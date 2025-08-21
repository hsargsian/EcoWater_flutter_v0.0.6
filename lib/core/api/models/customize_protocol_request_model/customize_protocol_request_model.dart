import 'package:echowater/core/domain/entities/customize_protocol_entity/customize_protocol_entity.dart';
import 'package:echowater/core/domain/entities/protocol_routine_entity/protocol_routine_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'customize_protocol_request_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CustomizeProtocolRequestModel {
  CustomizeProtocolRequestModel({
    required this.id,
    required this.title,
    required this.category,
    required this.image,
    required this.isActive,
    required this.isTemplate,
    required this.routines,
    this.protocol,
  });

  factory CustomizeProtocolRequestModel.fromJson(Map<String, dynamic> json) => _$CustomizeProtocolRequestModelFromJson(json);
  final int id;
  final String title;
  final String category;
  final String image;
  final bool isActive;
  final bool isTemplate;
  final List<Routine> routines;
  int? protocol;

  Map<String, dynamic> toJson() => _$CustomizeProtocolRequestModelToJson(this);

  CustomizeProtocolEntity asEntity() => CustomizeProtocolEntity(
        id: id,
        title: title,
        category: category,
        image: image,
        isActive: isActive,
        isTemplate: isTemplate,
        protocol: protocol,
        routines: routines.map((item) => item.asEntity()).toList(),
      );
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
