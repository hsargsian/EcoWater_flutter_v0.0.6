import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:echowater/core/domain/domain_models/flask_domain.dart';
import 'package:echowater/core/domain/domain_models/flask_wrapper_domain.dart';
import 'package:echowater/core/domain/repositories/flask_repository.dart';
import 'package:echowater/core/injector/injector.dart';
import 'package:echowater/core/services/bluetooth_settings.dart';
import 'package:echowater/core/services/crashlytics_service/crashlytics_service.dart';
import 'package:echowater/screens/dashboard/bloc/dashboard_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../../../../core/domain/domain_models/fetch_style.dart';
import '../../../../oc_libraries/ble_service/ble_manager.dart';

part 'my_flasks_listing_screen_event.dart';
part 'my_flasks_listing_screen_state.dart';

class MyFlasksListingScreenBloc
    extends Bloc<MyFlasksListingScreenEvent, MyFlasksListingScreenState> {
  MyFlasksListingScreenBloc({required FlaskRepository flaskRepository})
      : _flaskRepository = flaskRepository,
        super(MyFlasksListingScreenIdleState()) {
    on<FetchMyFlasksEvent>(_onFetchMyDevices);
    on<DeleteMyFlaskEvent>(_onDeleteDevice);
    on<TurnOnBluetoothEvent>(_turnOnBluetooth);
  }
  final FlaskRepository _flaskRepository;

  FlaskWrapperDomain bleDevicesWrapper = FlaskWrapperDomain(
    true,
    [],
  );

  Future<void> _onDeleteDevice(
    DeleteMyFlaskEvent event,
    Emitter<MyFlasksListingScreenState> emit,
  ) async {
    final response =
        await _flaskRepository.deleteFlask(flaskId: event.flask.id);
    response.when(success: (success) {
      bleDevicesWrapper.remove(flask: event.flask);
      BleManager().updateMyFlasks(
          bleDevicesWrapper.flasks.map((item) => item.serialId).toList());
      BleManager().disconnect(event.flask);
      emit(FlaskDeletedState());
    }, error: (error) {
      emit(MyFlasksScreenApiErrorState(error.toMessage()));
    });
  }

  Future<void> _onFetchMyDevices(
    FetchMyFlasksEvent event,
    Emitter<MyFlasksListingScreenState> emit,
  ) async {
    emit(FetchingMyFlasksState());
    var offset = 0;
    switch (event.fetchStyle) {
      case FetchStyle.normal:
      case FetchStyle.pullToRefresh:
        bleDevicesWrapper = FlaskWrapperDomain(
          true,
          [],
        );
      case FetchStyle.loadMore:
        offset = bleDevicesWrapper.flasks.length;
    }

    final response =
        await _flaskRepository.fetchMyFlasks(offset: offset, perPage: 10);
    response.when(success: (devicesResponse) {
      final newFlasks =
          devicesResponse.flasks.map((e) => e.toDomain()).toList();
      switch (event.fetchStyle) {
        case FetchStyle.normal:
        case FetchStyle.pullToRefresh:
          bleDevicesWrapper = devicesResponse.toDomain();
        case FetchStyle.loadMore:
          bleDevicesWrapper.hasMore = devicesResponse.pageMeta.hasMore;
          bleDevicesWrapper.flasks.addAll(newFlasks);
      }
      Injector.instance<DashboardBloc>().add(FetchAllFlasksEvent(false));

      bleDevicesWrapper.updateBLEModel();
      emit(FetchedMyFlasksState());
    }, error: (error) {
      emit(MyFlasksScreenApiErrorState(error.toMessage()));
    });
  }

  Future<void> _turnOnBluetooth(TurnOnBluetoothEvent event,
      Emitter<MyFlasksListingScreenState> emit) async {
    String? errorMessage;
    if (Platform.isAndroid) {
      try {
        await FlutterBluePlus.turnOn();
      } on FlutterBluePlusException catch (e) {
        errorMessage = 'The user declined the Bluetooth request.';
        await Injector.instance<CrashlyticsService>().recordError(e, null,
            reason: 'The user declined the Bluetooth request.');
      }
    } else if (Platform.isIOS) {
      FlutterBluePlus.adapterState.listen((state) async {
        if (state == BluetoothAdapterState.off) {
          await BluetoothSettings.openBluetoothSettings();
        }
      });
    }
    emit(TurnOnBluetoothState(
        isGoToNextPage: event.isGoToNextPage,
        flask: event.flask,
        errorMessage: errorMessage));
  }
}
