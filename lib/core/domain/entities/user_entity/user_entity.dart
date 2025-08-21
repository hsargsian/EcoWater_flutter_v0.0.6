import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:klaviyo_flutter/klaviyo_flutter.dart';

import '../../domain_models/user_domain.dart';

part 'user_entity.g.dart';

@JsonSerializable()
class UserEntity {
  UserEntity(
      this.id,
      this.email,
      this.firstName,
      this.lastName,
      this.phoneNumber,
      this.countryName,
      this.countryCode,
      this.avatarImage,
      this.theme,
      this.verified,
      this.hasPairedDevice,
      this.streaks,
      this.friendCount,
      this.friendStatus,
      this.createdAt,
      this.isHealthIntegrationEnabled);

  UserEntity.dummy({this.id = '1'})
      : email = '',
        firstName = 'John',
        lastName = 'Doe',
        // Changed 'test' to 'Doe' to be more typical for a last name,
        phoneNumber = '',
        countryName = 'US',
        countryCode = '1',
        avatarImage = null,
        theme = 'light',
        verified = true,
        hasPairedDevice = false,
        streaks = 0,
        friendCount = 0,
        friendStatus = '',
        createdAt = null,
        isHealthIntegrationEnabled = false;

  factory UserEntity.fromJson(Map<String, dynamic> json) => _$UserEntityFromJson(json);

  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final String countryName;
  final String countryCode;

  final String? avatarImage;
  final String theme;
  final bool verified;
  final bool hasPairedDevice;
  final int streaks;
  final int friendCount;

  // bool isFriend;
  String friendStatus;
  final String? createdAt;
  bool isHealthIntegrationEnabled = false;

  Map<String, dynamic> toJson() => _$UserEntityToJson(this);

  UserDomain toDomain(bool isMe) => UserDomain(this, isMe);

  KlaviyoProfile klaviyoProfile(Map<String, dynamic> additionalProperties) => KlaviyoProfile(
      id: id, email: email, firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, properties: additionalProperties);
}
