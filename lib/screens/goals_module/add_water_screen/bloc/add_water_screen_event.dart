part of 'add_water_screen_bloc.dart';

@immutable
abstract class AddWaterScreenEvent {}

class FetchUserInformationEvent extends AddWaterScreenEvent {
  FetchUserInformationEvent();
}

class ProfileEditRequestEvent extends AddWaterScreenEvent {
  ProfileEditRequestEvent(this.isHealthIntegrationEnabled);
  final bool isHealthIntegrationEnabled;
}

class AddWaterConsumptionEvent extends AddWaterScreenEvent {
  AddWaterConsumptionEvent(this.amount);
  final int amount;
}
