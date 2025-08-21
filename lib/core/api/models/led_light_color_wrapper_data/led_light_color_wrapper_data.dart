import 'package:echowater/core/api/models/led_light_color_wrapper_data/led_light_color_data.dart';
import 'package:echowater/core/domain/entities/led_light_color_entity/led_light_color_wrapper_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'led_light_color_wrapper_data.g.dart';

@JsonSerializable()
class LedLightColorWrapperData {
  LedLightColorWrapperData(
    this.id,
    this.title,
    this.colors,
  );

  factory LedLightColorWrapperData.fromJson(Map<String, dynamic> json) =>
      _$LedLightColorWrapperDataFromJson(json);
  final int id;
  final String title;
  final List<LedLightColorData> colors;

  Map<String, dynamic> toJson() => _$LedLightColorWrapperDataToJson(this);

  LedLightColorWrapperEntity asEntity() => LedLightColorWrapperEntity(
      title, colors.map((item) => item.asEntity()).toList());

  static List<LedLightColorWrapperData> getDummyData() {
    final gradientItems = [
      LedLightColorData(
        0,
        true, 'Primary Colors', 1,
        ['#FF0000', '#00FF00', '#0000FF'], // Red, Green, Blue
      ),
      LedLightColorData(
        1,
        true, 'Warm Gradient', 1,
        [
          '#FF5733',
          '#33FF57',
          '#3357FF',
        ], // Different shades of RGB
      ),
      LedLightColorData(
        2,
        true, 'Cool Gradient', 1,
        ['#FF6347', '#7FFF00', '#1E90FF'], // Another combination
      ),
    ];

    final singleColorItems = [
      LedLightColorData(
        0,
        false, 'Red', 1, ['#FF0000'], // Red
      ),
      LedLightColorData(
        1,
        false, 'Green', 1, ['#00FF00'], // Green
      ),
      LedLightColorData(
        2,
        false, 'Blue', 1, ['#0000FF'], // Blue
      ),
      LedLightColorData(
        3,
        false, 'Yellow', 1, ['#FFFF00'], // Yellow
      ),
      LedLightColorData(
        4,
        false, 'Cyan', 1, ['#00FFFF'], // Cyan
      ),
      LedLightColorData(
        5,
        false, 'Magenta', 1, ['#FF00FF'], // Magenta
      ),
      LedLightColorData(
        6,
        false, 'Orange', 1, ['#FFA500'], // Orange
      ),
      LedLightColorData(
        7,
        false, 'Purple', 1, ['#800080'], // Purple
      ),
      LedLightColorData(
        8,
        false, 'Pink', 1, ['#FFC0CB'], // Pink
      ),
      LedLightColorData(
        9,
        false, 'Brown', 1, ['#A52A2A'], // Brown
      ),
    ];
    return [
      LedLightColorWrapperData(1, 'Gradient', gradientItems),
      LedLightColorWrapperData(2, 'Solids', singleColorItems)
    ];
  }
}
