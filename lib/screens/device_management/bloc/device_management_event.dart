part of 'device_management_bloc.dart';

@immutable
abstract class DeviceManagementEvent {}

class UpdateDeviceEvent extends DeviceManagementEvent {
  UpdateDeviceEvent();
}

class AddInitialPushNotificationListenerEvent extends DeviceManagementEvent {
  AddInitialPushNotificationListenerEvent();
}

class EvictUserEvent extends DeviceManagementEvent {}
