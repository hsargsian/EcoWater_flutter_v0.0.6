import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/user_entity/user_entity.dart';

part 'user_data.g.dart';

@JsonSerializable()
class UserData {
  UserData(
      this.id,
      this.email,
      this.verified,
      this.firstName,
      this.lastName,
      this.phoneNumber,
      this.countryName,
      this.countryCode,
      this.avatarImage,
      this.theme,
      this.hasPairedDevice,
      this.streaks,
      this.friendCount,
      this.friendStatus,
      this.createdAt,
      this.isHealthIntegrationEnabled);

  factory UserData.fromJson(Map<String, dynamic> json) => _$UserDataFromJson(json);

  final String id;
  final String email;
  @JsonKey(name: 'is_verified')
  final bool? verified;
  @JsonKey(name: 'first_name')
  final String firstName;
  @JsonKey(name: 'last_name')
  final String lastName;
  @JsonKey(name: 'phone_number')
  final String? phoneNumber;
  @JsonKey(name: 'country_name')
  String? countryName;
  @JsonKey(name: 'country_code')
  String? countryCode;

  @JsonKey(name: 'image')
  final String? avatarImage;
  final String? theme;

  @JsonKey(name: 'has_paired_device')
  final bool? hasPairedDevice;
  @JsonKey(name: 'current_streak')
  final int? streaks;
  @JsonKey(name: 'friends_count')
  final int? friendCount;
  @JsonKey(name: 'friend_status')
  final String? friendStatus;
  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'is_health_integration_enabled')
  final bool? isHealthIntegrationEnabled;

  Map<String, dynamic> toJson() => _$UserDataToJson(this);

  UserEntity asEntity() => UserEntity(
      id,
      email,
      firstName,
      lastName,
      phoneNumber,
      countryName ?? 'US',
      countryCode ?? '1',
      avatarImage,
      theme ?? 'defaultTheme',
      verified ?? false,
      hasPairedDevice ?? false,
      streaks ?? 0,
      friendCount ?? 0,
      friendStatus ?? '',
      createdAt,
      isHealthIntegrationEnabled ?? false);
}
