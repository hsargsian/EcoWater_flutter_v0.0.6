import 'package:bloc/bloc.dart';
import 'package:echowater/base/common_widgets/snackbar/snackbar_style.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/core/domain/domain_models/flask_domain.dart';
import 'package:echowater/core/domain/repositories/flask_repository.dart';
import 'package:echowater/oc_libraries/ble_service/app_ble_model.dart';
import 'package:echowater/oc_libraries/ble_service/ble_manager.dart';
import 'package:flutter/material.dart';

import '../../../core/domain/domain_models/flask_firmware_version_domain.dart';
import '../../../core/domain/domain_models/flask_wrapper_domain.dart';
import '../../../core/domain/domain_models/system_access_state_domain.dart';
import '../../../core/domain/domain_models/user_domain.dart';
import '../../../core/domain/entities/system_access_entity/system_access_entity.dart';
import '../../../core/domain/repositories/other_repository.dart';
import '../../../core/domain/repositories/user_repository.dart';
import '../../../core/injector/injector.dart';
import '../../../core/services/refresh.dart';
import '../../../theme/app_theme_manager.dart';
import '../../auth/authentication/bloc/authentication_bloc.dart';
import '../../device_management/app_state.dart';
import '../../device_management/in_app_notification.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc(
      {required UserRepository userRepository,
      required FlaskRepository flaskRepository,
      required OtherRepository otherRepository})
      : _userRepository = userRepository,
        _flaskRepository = flaskRepository,
        _otherRepository = otherRepository,
        super(DashboardIdleState()) {
    on<DashboardFetchUserInfoEvent>(_onFetchUserInfo);
    on<UpdateThemeEvent>(_onUpdateTheme);
    on<InAppNotificationReceivedEvent>(_inAppNotificationReceived);
    on<FetchAllFlasksEvent>(_onFetchMyDevices);
    on<StartCycleEvent>(_onStartCycle);
    on<FetchSystemAccessEvent>(_onFetchSystemAccessState);
    on<FetchFlaskFirmwareVersionEvent>(_onFetchFlaskFirmwareVersionEvent);
  }

  UserDomain? user;
  final UserRepository _userRepository;
  final FlaskRepository _flaskRepository;
  final OtherRepository _otherRepository;

  FlaskWrapperDomain bleDevicesWrapper = FlaskWrapperDomain(
    true,
    [],
  );
  SystemAccessStateDomain? systemAccessInfo;

  Future<void> _onFetchSystemAccessState(
    FetchSystemAccessEvent event,
    Emitter<DashboardState> emit,
  ) async {
    final response = await _otherRepository.getSystemAccessState();
    response.when(success: (responseObj) {
      systemAccessInfo = SystemAccessStateDomain(responseObj);
      if (systemAccessInfo != null &&
          systemAccessInfo!.accessDate().isBefore(DateTime.now())) {
        systemAccessInfo = SystemAccessStateDomain(
            SystemAccessEntity(true, responseObj.accessDate));
        emit(FetchedSystemAccessState(systemAccessInfo!));
        return;
      }
      emit(FetchedSystemAccessState(systemAccessInfo!));
    }, error: (error) {
      emit(MessageState(error.toMessage(), SnackbarStyle.error));
    });
  }

  Future<void> _onUpdateTheme(
    UpdateThemeEvent event,
    Emitter<DashboardState> emit,
  ) async {
    final response = await _userRepository.updateTheme(
        userId: user!.id, theme: event.theme.key);
    response.when(success: (userEntity) {
      user = UserDomain(userEntity, true);
      AppThemeManager().changeTheme(user!.theme);
      emit(FetchedUserInfoState());
    }, error: (error) {
      emit(MessageState(error.toMessage(), SnackbarStyle.error));
    });
  }

  Future<void> _onFetchMyDevices(
    FetchAllFlasksEvent event,
    Emitter<DashboardState> emit,
  ) async {
    final response =
        await _flaskRepository.fetchMyFlasks(offset: 0, perPage: 100);
    response.when(success: (devicesResponse) {
      bleDevicesWrapper = devicesResponse.toDomain();
      if (event.initatesConnect) {
        emit(FetchedMyFlasksState(bleDevicesWrapper.flasks));
      }
    }, error: (error) {
      emit(MessageState(error.toMessage(), SnackbarStyle.error));
    });
  }

  Future<void> _onFetchFlaskFirmwareVersionEvent(
    FetchFlaskFirmwareVersionEvent event,
    Emitter<DashboardState> emit,
  ) async {
    final response = await _flaskRepository.fetchFlaskVersion(
        flaskId: event.flaskSerialId,
        mcuVersion: event.mcuVersion,
        bleVersion: event.bleVersion);

    response.when(
        success: (flaskFirmwareResponse) {
          final itemIndex = bleDevicesWrapper.flasks
              .indexWhere((item) => item.aliasId == event.flaskSerialId);
          if (itemIndex == -1) {
            return;
          }
          final firmwareInfo =
              FlaskFirmwareVersionDomain(flaskFirmwareResponse);

          emit(FlaskFirmwareInfoFetchedState(
              firmwareInfo, bleDevicesWrapper.flasks[itemIndex]));
        },
        error: (error) {});
  }

  Future<void> _onStartCycle(
    StartCycleEvent event,
    Emitter<DashboardState> emit,
  ) async {
    print('~~~~~~~~~~~~ Starting cycle ~~~~~~~~~~~~~');
    final itemIndex = bleDevicesWrapper.flasks
        .indexWhere((item) => item.aliasId == event.flask.aliasIdentifier);
    if (itemIndex == -1) {
      return;
    }
    final response = await _flaskRepository.startFlaskCycle(
        id: bleDevicesWrapper.flasks[itemIndex].id,
        ppmGenerated: event.ppmGenerated);
    response.when(success: (success) {
      Refresher().refreshHomeScreen?.call();
      Refresher().refreshGoalScreen?.call();
      Refresher().refreshProfileScreen?.call();
      final manager =
          BleManager().getManager(bleDevicesWrapper.flasks[itemIndex]);
      if (manager != null) {
        print('~~~~~~~~~~~~ Clear Data Log ~~~~~~~~~~~~~');
        BleManager().clearDataLog(manager);
        print('~~~~~~~~~~~~ Send Batch Logs to Backend ~~~~~~~~~~~~~');
        manager.sendBatchLogsToBackend();
      }
      emit(MessageState('MyFlaskListingScreen_flaskCycleStarted'.localized,
          SnackbarStyle.success));
    }, error: (error) {
      Refresher().refreshHomeScreen?.call();
      Refresher().refreshGoalScreen?.call();
      Refresher().refreshProfileScreen?.call();
      // remove this
      final manager =
          BleManager().getManager(bleDevicesWrapper.flasks[itemIndex]);
      if (manager != null) {
        BleManager().clearDataLog(manager);
        manager.sendBatchLogsToBackend();
      }
      emit(MessageState(error.toMessage(), SnackbarStyle.error));
    });
  }

  Future<void> _onFetchUserInfo(
    DashboardFetchUserInfoEvent event,
    Emitter<DashboardState> emit,
  ) async {
    final currentUserId = await _userRepository.getCurrentUserId();
    if (currentUserId == null) {
      emit(MessageState('user_session_expired_message', SnackbarStyle.error));
      Injector.instance<AuthenticationBloc>().add(
          ExpireUserSessionEvent(resetsDevice: true, deleteAccount: false));
      return;
    }
    final response =
        await _userRepository.fetchProfileInformation(userId: currentUserId);
    response.when(success: (userEntity) {
      user = UserDomain(userEntity, true);
      AppThemeManager().changeTheme(user!.theme);
      emit(FetchedUserInfoState());
    }, error: (error) {
      emit(MessageState(error.toMessage(), SnackbarStyle.error));
    });
  }

  Future<void> _inAppNotificationReceived(
    InAppNotificationReceivedEvent event,
    Emitter<DashboardState> emit,
  ) async {}
}
