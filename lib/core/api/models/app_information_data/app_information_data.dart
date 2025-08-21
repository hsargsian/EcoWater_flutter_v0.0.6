import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/app_information_entity/app_information_entity.dart';

part 'app_information_data.g.dart';

@JsonSerializable()
class AppInformationData {
  AppInformationData(
      this.androidLink, this.androidVersion, this.iosLink, this.iosVersion);

  factory AppInformationData.fromJson(Map<String, dynamic> json) =>
      _$AppInformationDataFromJson(json);
  final String androidLink;
  final String androidVersion;
  final String iosLink;
  final String iosVersion;

  AppInformationEntity asEntity() => AppInformationEntity(
      androidLink: androidLink,
      androidVersion: androidVersion,
      iosLink: iosLink,
      iosVersion: iosVersion);
}
