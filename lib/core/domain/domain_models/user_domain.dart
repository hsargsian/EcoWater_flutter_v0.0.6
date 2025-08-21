import 'package:echowater/base/utils/date_utils.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:equatable/equatable.dart';

import '../../../base/utils/utilities.dart';
import '../../../theme/app_theme_manager.dart';
import '../entities/user_entity/user_entity.dart';
import 'flask_domain.dart';

enum FriendAction { none, friend, requestSent, requestReceived }

class UserDomain extends Equatable {
  const UserDomain(this._userEntity, this.isMe);

  final UserEntity _userEntity;
  final bool isMe;

  UserEntity get userEntity => _userEntity;

  String get id => _userEntity.id;

  String get email => _userEntity.email;

  String get firstName => _userEntity.firstName;

  String get capitalizedFirstname => Utilities.capitalizeEachWord(firstName);

  String get lastName => _userEntity.lastName;

  String get name => [firstName, lastName].join(' ');

  String get streaks => _userEntity.streaks.toString();

  String get friendCount => _userEntity.friendCount.toString();

  String get phoneNumber => _userEntity.phoneNumber ?? '';

  String get countryName => _userEntity.countryName;

  String get countryCode => _userEntity.countryCode;

  bool get isAccountVerified => _userEntity.verified;

  bool get hasPairedDevice => _userEntity.hasPairedDevice;

  String get friendStatus => _userEntity.friendStatus;

  bool get isHealthIntegrationEnabled => _userEntity.isHealthIntegrationEnabled;

  String? primaryImageUrl() {
    return _userEntity.avatarImage;
  }

  bool get hasCompletedWeekOneTraining => false;

  DateTime? get accountCreationDate => _userEntity.createdAt == null ? null : DateTime.parse(_userEntity.createdAt!).startOfDay;

  String? get accountCreatedDateString => _userEntity.createdAt;

  String friendActionTitle() {
    switch (friendAction) {
      case FriendAction.friend:
        return 'Friend'.localized;
      case FriendAction.requestSent:
        return 'Request_sent'.localized;
      case FriendAction.requestReceived:
        return 'Confirm'.localized;
      default:
        return 'Add Friend'.localized;
    }
  }

  FriendAction get friendAction {
    switch (friendStatus.toLowerCase()) {
      case 'friend':
        return FriendAction.friend;
      case 'request_sent':
        return FriendAction.requestSent;
      case 'request_received':
        return FriendAction.requestReceived;
      default:
        return FriendAction.none;
    }
  }

  @override
  List<Object?> get props => [id];

  AppTheme get theme {
    switch (_userEntity.theme) {
      case 'dark':
        return AppTheme.dark;
      case 'light':
        return AppTheme.light;
      default:
        return AppTheme.defaultTheme;
    }
  }

  void unfriend() {
    _userEntity.friendStatus = 'friend';
  }

  String fueledByText(List<FlaskDomain> flasks) {
    if (flasks.isEmpty) {
      return '';
    }
    if (flasks.length == 1) {
      return "${'FueledBy'.localized} ${flasks.first.name}!";
    }
    return "${'FueledBy'.localized}${flasks.first.name} and ${flasks.length - 1} other flasks!";
  }
}
