import 'package:json_annotation/json_annotation.dart';

part 'profile_image_data.g.dart';

@JsonSerializable()
class ProfileImageData {
  ProfileImageData(this.url);

  factory ProfileImageData.fromJson(Map<String, dynamic> json) =>
      _$ProfileImageDataFromJson(json);
  final String url;

  Map<String, dynamic> toJson() => _$ProfileImageDataToJson(this);
}
