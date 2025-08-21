part of 'add_water_screen_bloc.dart';

abstract class AddWaterScreenState {}

class IntegrationSettingsIdleState extends AddWaterScreenState {}

class ProfileFetchedState extends AddWaterScreenState {
  ProfileFetchedState(this.userProfile);
  final UserDomain userProfile;
}

class ProfileUpdateCompleteState extends AddWaterScreenState {
  ProfileUpdateCompleteState(this.message);
  final String message;
}

class UpdatingProfileState extends AddWaterScreenState {}

class ProfileEditApiErrorState extends AddWaterScreenState {
  ProfileEditApiErrorState(this.errorMessage);
  final String errorMessage;
}

class WaterConsumptionAdditionSuccessfulState extends AddWaterScreenState {
  WaterConsumptionAdditionSuccessfulState(this.message);
  final String message;
}
