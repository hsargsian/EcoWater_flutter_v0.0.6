import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../base/utils/utilities.dart';
import '../../../core/domain/repositories/device_repository.dart';
import '../../../core/services/push_notification_service/push_notification_service.dart';
import '../../../oc_libraries/device_information_retrieval/device_information_retrieval_service.dart';

part 'device_management_event.dart';
part 'device_management_state.dart';

class DeviceManagementBloc
    extends Bloc<DeviceManagementEvent, DeviceManagementState> {
  DeviceManagementBloc({
    required DeviceRepository deviceRepository,
    required DeviceInformationRetrievalService
        deviceInformationRetrievalService,
    required PushNotificationService pushNotificationService,
  })  : _deviceRepository = deviceRepository,
        _deviceInformationRetrievalService = deviceInformationRetrievalService,
        _pushNotificationService = pushNotificationService,
        super(DeviceManagementIdleState()) {
    on<UpdateDeviceEvent>(_onUpdateDevice);
    on<EvictUserEvent>(_onEvictUser);
    on<AddInitialPushNotificationListenerEvent>(
        _onAddInitialPushNotificationHandler);
  }

  final DeviceRepository _deviceRepository;
  final PushNotificationService _pushNotificationService;
  final DeviceInformationRetrievalService _deviceInformationRetrievalService;

  Future<void> _onUpdateDevice(
      UpdateDeviceEvent event, Emitter<DeviceManagementState> emit) async {
    final info =
        await _deviceInformationRetrievalService.fetchDeviceInformation();
    if (!info.isPhysicalDevice) {
      return;
    }
    final pushToken = await _pushNotificationService.getPushToken();
    if (pushToken == null) {
      return;
    }
    final response = await _deviceRepository.updateDevice(
        deviceId: info.name, pushToken: pushToken);

    response.when(
        success: (_) {},
        error: (error) {
          Utilities.printObj(error.toMessage());
        });
  }

  Future<void> _onAddInitialPushNotificationHandler(
      AddInitialPushNotificationListenerEvent event,
      Emitter<DeviceManagementState> emit) async {
    await _pushNotificationService.addInitialMessageListener();
  }

  Future<void> _onEvictUser(
      EvictUserEvent event, Emitter<DeviceManagementState> emit) async {
    _pushNotificationService.resetFCMToken();
    await _deviceRepository.removeDevice();
  }
}
