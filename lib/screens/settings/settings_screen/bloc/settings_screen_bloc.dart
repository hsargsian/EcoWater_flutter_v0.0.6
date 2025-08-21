import 'package:bloc/bloc.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/core/domain/domain_models/settings_domain.dart';
import 'package:echowater/core/domain/domain_models/settings_type.dart';
import 'package:echowater/core/domain/entities/settings_entity/settings_entity.dart';
import 'package:flutter/material.dart';

import '../../../../base/utils/pair.dart';
import '../../../../core/domain/domain_models/notification_setting_type.dart';
import '../../../../core/domain/repositories/user_repository.dart';

part 'settings_screen_event.dart';
part 'settings_screen_state.dart';

class SettingsScreenBloc
    extends Bloc<SettingsScreenEvent, SettingsScreenState> {
  SettingsScreenBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(SettingsScreenIdleState()) {
    on<FetchSettingsEvent>(_onFetchSettings);
    on<SetSettingsTypeEvent>(_onSetSettingsType);
    on<UpdateSettingsEvent>(_onUpdateSettings);
  }

  final UserRepository _userRepository;
  SettingsType settingsType = SettingsType.emailNotification;
  late SettingsDomain settings;
  bool hasFetchedSettings = false;
  List<Pair<NotificationType, bool>> settingsTypes =
      <Pair<NotificationType, bool>>[];

  Future<void> _onUpdateSettings(
    UpdateSettingsEvent event,
    Emitter<SettingsScreenState> emit,
  ) async {
    emit(UpdatingSettingsState());
    final data = <String, bool>{};
    for (final item in event.notificationSettings) {
      data[item.first.key] = item.second;
    }
    final response = await _userRepository.updateSettings(settings: data);
    response.when(success: (settingsResponse) {
      _onSettingsFetched(settingsResponse);
      emit(UpdatedSettingsState('settings_screen_updated_message'.localized));
    }, error: (error) {
      emit(SettingsScreenApiErrorState(error.toMessage()));
    });
  }

  Future<void> _onSetSettingsType(
    SetSettingsTypeEvent event,
    Emitter<SettingsScreenState> emit,
  ) async {
    settingsType = event.settingsType;
  }

  Future<void> _onFetchSettings(
    FetchSettingsEvent event,
    Emitter<SettingsScreenState> emit,
  ) async {
    emit(FetchingSettingsState());
    final response = await _userRepository.fetchSettings();
    response.when(success: (settingsResponse) {
      hasFetchedSettings = true;
      _onSettingsFetched(settingsResponse);
      emit(FetchedSettingsState());
    }, error: (error) {
      emit(SettingsScreenApiErrorState(error.toMessage()));
    });
  }

  void _onSettingsFetched(SettingsEntity settingsResponse) {
    settings = SettingsDomain(settingsResponse);
    switch (settingsType) {
      case SettingsType.emailNotification:
        settingsTypes = [
          Pair(
              first: NotificationType.promotionalEmails,
              second: settings.promotionalEmail),
          Pair(
              first: NotificationType.accountUpdates,
              second: settings.accountUpdates)
        ];
      case SettingsType.pushNotification:
        settingsTypes = [
          Pair(
              first: NotificationType.progressNotifications,
              second: settings.progressNotifications),
          Pair(
              first: NotificationType.newsNotifications,
              second: settings.newsNotifications),
          Pair(
              first: NotificationType.bottleNotifications,
              second: settings.bottleNotifications)
        ];
    }
  }
}
