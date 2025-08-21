import 'package:echowater/core/api/models/led_light_color_wrapper_data/led_light_color_wrapper_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'led_color_response_wrapper_data.g.dart';

@JsonSerializable()
class LedColorResponseWrapperData {
  LedColorResponseWrapperData(this.results);

  factory LedColorResponseWrapperData.fromJson(Map<String, dynamic> json) =>
      _$LedColorResponseWrapperDataFromJson(json);

  final List<LedLightColorWrapperData> results;

  Map<String, dynamic> toJson() => _$LedColorResponseWrapperDataToJson(this);
}
