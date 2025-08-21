import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_data.g.dart';

@JsonSerializable()
class DeviceData {
  DeviceData(this.id);

  factory DeviceData.fromJson(Map<String, dynamic> json) =>
      _$DeviceDataFromJson(json);
  final String id;
  Map<String, dynamic> toJson() => _$DeviceDataToJson(this);
}
