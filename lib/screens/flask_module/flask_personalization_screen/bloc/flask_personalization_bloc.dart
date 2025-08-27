import 'package:bloc/bloc.dart';
import 'dart:async';
import 'package:echowater/base/constants/constants.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/core/domain/domain_models/flask_domain.dart';
import 'package:echowater/core/domain/domain_models/flask_option.dart';
import 'package:echowater/core/domain/domain_models/led_light_color_domain.dart';
import 'package:echowater/core/domain/entities/led_light_color_entity/led_light_color_entity.dart';
import 'package:echowater/oc_libraries/ble_service/ble_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../core/domain/domain_models/flask_firmware_version_domain.dart';
import '../../../../core/domain/entities/flask_firmware_version_entity/flask_firmware_version_entity.dart';
import '../../../../core/domain/entities/DevicePersonalizationSettingsEntity/device_personalization_settings_entity.dart';
import '../../../../core/domain/repositories/flask_repository.dart';
import '../../../../core/domain/repositories/user_repository.dart';
import '../../../../core/injector/injector.dart';
import '../../../auth/authentication/bloc/authentication_bloc.dart';

part 'flask_personalization_event.dart';
part 'flask_personalization_state.dart';

class FlaskPersonalizationBloc
    extends Bloc<FlaskPersonalizationEvent, FlaskPersonalizationState> {
  FlaskPersonalizationBloc(
      {required FlaskRepository flaskRepository,
      required UserRepository userRepository})
      : _flaskRepository = flaskRepository,
        _userRepository = userRepository,
        super(FlaskPersonalizationIdleState()) {
    on<SetFlaskDetailEvent>(_onSetFlaskDetails);
    on<UpdateFlaskLightMode>(_onUpdateFlaskLightMode);
    on<UpdateFlaskName>(_onUpdateFlaskName);
    on<UpdateFlaskColor>(_onUpdateFlaskColor);
    on<UpdateFlaskRequestEvent>(_onUpdateFlask);
    on<UpdateFlaskVolume>(_onUpdateFlaskVolume);
    on<UpdateFlaskWakeUpFromSleepTime>(_onUpdateWakeUpFromSleepTime);
    on<FetchFlaskFirmwareVersionEvent>(_onFetchFlaskFirmwareVersionEvent);
    on<FlaskPersonalizationSettingsEvent>(_onFlaskPersonalizationSettingsEvent);
  }

  final FlaskRepository _flaskRepository;
  final UserRepository _userRepository;

  late FlaskDomain flask;
  bool hasInitialized = false;
  bool isLightMode = true;
  double flaskVolume = Constants.defaultFlaskVolume.toDouble();
  int wakeUpFromSleepTime = Constants.defaultWakeFromSleepTime;
  late LedLightColorDomain selectedColor;

  FlaskFirmwareVersionDomain? firmwareInfo;
  // Keep complete response data
  FlaskFirmwareVersionEntity? firmwareInfoRawResponse;

  // Store all firmware responses in an array
  List<FlaskFirmwareVersionEntity> _firmwareResponses = [];

  // Firmware upgrade paths storage (latest values for backward compatibility)
  String? _blePath;
  String? _mcuPath;
  List<String> _imagePaths = [];

  // Retry mechanism for firmware fetching
  Timer? _firmwareRetryTimer;
  int _firmwareRetryCount = 0;
  static const int _maxRetryAttempts = 5;
  static const int _retryIntervalSeconds = 10;

  DevicePersonalizationSettingsEntity personalizationSettings =
      DevicePersonalizationSettingsEntity(
          hasLedLightSettings: false,
          hasVolumeControls: false,
          hasLedModeSettings: false,
          hasSleepWakeSettings: false);

  // Getters for latest upgrade paths (backward compatibility)
  String? get blePath => _blePath;
  String? get mcuPath => _mcuPath;
  List<String> get imagePaths => List.unmodifiable(_imagePaths);

  // Getters for all firmware responses
  List<FlaskFirmwareVersionEntity> get allFirmwareResponses =>
      List.unmodifiable(_firmwareResponses);

  int get firmwareResponseCount => _firmwareResponses.length;

  // Get all BLE paths from all responses
  List<String> get allBlePaths {
    return _firmwareResponses
        .map((response) => response.blePath)
        .where((path) => path != null)
        .cast<String>()
        .toList();
  }

  // Get all MCU paths from all responses
  List<String> get allMcuPaths {
    return _firmwareResponses
        .map((response) => response.mcuPath)
        .where((path) => path != null)
        .cast<String>()
        .toList();
  }

  // Get all image paths from all responses (flattened)
  List<String> get allImagePaths {
    List<String> allImages = [];
    for (var response in _firmwareResponses) {
      if (response.imagePaths != null) {
        allImages.addAll(response.imagePaths!);
      }
    }
    return allImages;
  }

  // Getter to check if any upgrades are available
  bool get hasUpgradesAvailable =>
      _blePath != null || _mcuPath != null || _imagePaths.isNotEmpty;

  // Getter for complete firmware response information
  Map<String, dynamic>? get completeFirmwareResponse =>
      firmwareInfoRawResponse?.toJson();

  // Check if we have complete firmware data
  bool get hasCompleteFirmwareData => firmwareInfoRawResponse != null;

  String? mcuVersion = null;

  Future<String?> _getMCUVersion(String mcuURL) async {
    // Handle empty or invalid URL
    if (mcuURL.isEmpty) {
      print('MCU URL is empty, returning null');
      return null;
    }

    // Step 1: Extract filename from URL
    final filename = mcuURL.split('/').last; // MCU_OTA_OfficialVersionV5_0.bin
    print('filename: $filename');
    print('mcuURL: $mcuURL');

    // Step 2: Extract version using RegExp
    final versionMatch = RegExp(r'V(\d+_\d+)').firstMatch(filename);
    if (versionMatch != null && versionMatch.group(1) != null) {
      final versionUnderscore = versionMatch.group(1)!; // e.g. "5_0"
      final versionDot = versionUnderscore.replaceAll('_', '.'); // "5.0"

      print('Version (dot format): $versionDot');

      // Example: Replace "5.0" in a string
      String originalText = "Current version is 5.0";
      String updatedText =
          originalText.replaceAll(RegExp(r'\b\d+\.\d+\b'), versionDot);

      print('Updated text: $updatedText');
      return versionDot;
    } else {
      print('Version not found in filename');
      return null;
    }
  }

  /// Synchronous version extraction for getAllUpgradeData
  String _extractMcuVersionSync(String mcuURL) {
    if (mcuURL.isEmpty) return "";

    final filename = mcuURL.split('/').last;
    final versionMatch = RegExp(r'V(\d+_\d+)').firstMatch(filename);
    if (versionMatch != null && versionMatch.group(1) != null) {
      final versionUnderscore = versionMatch.group(1)!;
      return versionUnderscore.replaceAll('_', '.');
    }
    return "";
  }

  Future<void> _onFetchFlaskFirmwareVersionEvent(
    FetchFlaskFirmwareVersionEvent event,
    Emitter<FlaskPersonalizationState> emit,
  ) async {
    // Reset upgrade flag when starting fresh firmware check
    flask.resetUpgradeFlag();

    print(
        ' event onFetchFlaskFirmwareVersionEvent - Attempt ${_firmwareRetryCount + 1}');
    print('_____________________ event mcuVersion: ${event.mcuVersion}');
    print('_____________________ event bleVersion: ${event.bleVersion}');
    print('_____________________ event mcuVersion: ${mcuVersion}');

    if (mcuVersion == '-1') {
      return;
    }

    try {
      final response = await _flaskRepository.fetchFlaskVersion(
        flaskId: flask.id,
        mcuVersion: event.mcuVersion,
        bleVersion: event.bleVersion,
      );

      await response.when(
        success: (flaskFirmwareResponse) async {
          print('✅ Firmware fetch successful!');
          print('Current Version: ${flaskFirmwareResponse.currentVersion}');
          print('BLE Path: ${flaskFirmwareResponse.blePath}');
          print('MCU Path: ${flaskFirmwareResponse.mcuPath}');
          print(
              'Image Paths: ${flaskFirmwareResponse.imagePaths?.length ?? 0}');
          if (flaskFirmwareResponse.mcuPath != null) {
            mcuVersion =
                _extractMcuVersionSync(flaskFirmwareResponse.mcuPath ?? '');
            _mcuPath = flaskFirmwareResponse.mcuPath;
          } else {
            mcuVersion = '-1';
          }
          print('mcuPath: $_mcuPath');

          // Store both raw response and domain object
          firmwareInfoRawResponse = flaskFirmwareResponse;
          firmwareInfo = FlaskFirmwareVersionDomain(flaskFirmwareResponse);
          print(
              "________ firmwareInfo: $firmwareInfo  firmwareInfo.hasUpdate: ${firmwareInfo?.hasUpgrade}");
          // Extract and store upgrade paths from the firmware response
          _extractUpgradePaths(flaskFirmwareResponse);

          // Debug: Log the stored upgrade paths
          logStoredUpgradePaths();

          // Update Flask versions if we have new version info
          await _updateFlaskVersionsIfNeeded(event, emit);

          // Clear retry timer and reset counter
          _firmwareRetryTimer?.cancel();
          _firmwareRetryCount = 0;
          emit(FlaskFirmwareInfoFetchedState());
        },
        error: (error) {
          print('❌ Firmware fetch failed: $error');
          print('Retry count: $_firmwareRetryCount/$_maxRetryAttempts');

          if (_firmwareRetryCount < _maxRetryAttempts) {
            _scheduleRetry(event, emit);
          } else {
            print('⛔ Max retries reached. Creating default firmware info.');
            _firmwareRetryTimer?.cancel();
            _firmwareRetryCount = 0;

            // Create default firmware info instead of leaving it null
            final defaultEntity = FlaskFirmwareVersionEntity(
              null, // currentVersion
              null, // blePath
              null, // mcuPath
              null, // imagePaths
              false, // mandatoryVersionCheck
            );
            firmwareInfo = FlaskFirmwareVersionDomain(defaultEntity);

            emit(FlaskFirmwareInfoFetchedState());
          }
        },
      );
    } catch (error) {
      print('💥 Unexpected error: $error');

      // Create default firmware info for any unexpected errors
      final defaultEntity = FlaskFirmwareVersionEntity(
        null,
        null,
        null,
        null,
        false,
      );
      firmwareInfo = FlaskFirmwareVersionDomain(defaultEntity);
      emit(FlaskFirmwareInfoFetchedState());
    }
  }

  /// Extract upgrade paths from firmware response and store them
  void _extractUpgradePaths(FlaskFirmwareVersionEntity firmwareResponse) {
    print('=== Extracting Upgrade Paths ===');

    // Add complete firmware response to the array
    _firmwareResponses.add(firmwareResponse);
    print(
        'Added firmware response to array. Total responses: ${_firmwareResponses.length}');

    // Extract BLE path (keep latest for backward compatibility)
    _blePath = firmwareResponse.blePath;
    print('BLE Path: $_blePath');

    // Extract MCU path (keep latest for backward compatibility)
    _mcuPath = firmwareResponse.mcuPath;
    print('MCU Path: $_mcuPath');

    // Extract image paths (keep latest for backward compatibility)
    _imagePaths = firmwareResponse.imagePaths ?? [];
    print('Image Paths: $_imagePaths');
    print('Total Image Paths: ${_imagePaths.length}');

    print('Has upgrades available: $hasUpgradesAvailable');
    print('Total firmware responses stored: ${_firmwareResponses.length}');
    print('==================================');
  }

  Future<void> _updateFlaskVersionsIfNeeded(
    FetchFlaskFirmwareVersionEvent event,
    Emitter<FlaskPersonalizationState> emit,
  ) async {
    // Extract versions from firmware response (source of truth)
    String? newBleVersion;
    String? newMcuVersion;

    print('=== Extracting Versions from Firmware Response ===');

    // Primary source: firmware response data
    if (firmwareInfoRawResponse != null) {
      // BLE Version from currentVersion field
      newBleVersion = firmwareInfoRawResponse!.currentVersion;
      print('BLE Version from firmware response: $newBleVersion');

      // Try to extract MCU version from firmware response
      // First check the new mcuVersion field (after model update)
      // if (firmwareInfoRawResponse!.mcuVersion != null) {
      //   newMcuVersion = firmwareInfoRawResponse!.mcuVersion;
      //   print('✅ MCU Version from mcuVersion field: $newMcuVersion');
      // } else {
      // Fallback: check raw response for other possible fields
      final rawResponse = firmwareInfoRawResponse!.toJson();
      print('Complete raw response: $rawResponse');
      print('Available fields: ${rawResponse.keys.toList()}');

      // }
    }

    // Fallback: Use BLE manager if firmware response doesn't have complete versions
    final manager = BleManager().getManager(flask);
    if (newBleVersion == null && manager != null) {
      newBleVersion = manager.bleVersion ?? event.bleVersion;
      print('Fallback BLE Version from manager: $newBleVersion');
    }
    newMcuVersion = mcuVersion;

    if (newMcuVersion == null && manager != null) {
      newMcuVersion =
          manager.mcuVersion?.toString() ?? event.mcuVersion?.toString();
      newMcuVersion =
          await _getMCUVersion(manager.mcuVersion?.toString() ?? '');
      print(
          'Fallback MCU Version from manager: $newMcuVersion, event.mcuVersion: ${event.mcuVersion}, manager.mcuVersion: ${manager.mcuVersion}');
    }

    // Final fallback: Use original event parameters
    newBleVersion ??= event.bleVersion;
    newMcuVersion ??= event.mcuVersion?.toString();

    print('=== Version Extraction Results ===');
    print('Extracted BLE Version: $newBleVersion');
    print('Extracted MCU Version: $newMcuVersion');
    print('Current Flask BLE Version: ${flask.bleVersion}');
    print('Current Flask MCU Version: ${flask.mcuVersion}');
    // if (firmwareInfoRawResponse?.mcuVersion != null) {
    //   print(
    //       '✅ Available mcuVersion field: ${firmwareInfoRawResponse!.mcuVersion}');
    // }
    print('==================================');

    // Check if we have different version info and need to update
    bool needsUpdate = true;

    if (newBleVersion != flask.bleVersion) {
      print('BLE version changed: ${flask.bleVersion} -> $newBleVersion');
      needsUpdate = true;
    }

    if (newMcuVersion != flask.mcuVersion) {
      print('MCU version changed: ${flask.mcuVersion} -> $newMcuVersion');
      needsUpdate = true;
    }

    if (needsUpdate) {
      print('Updating Flask versions...');
      print('  Current BLE Version: ${flask.bleVersion}');
      print('  Current MCU Version: ${flask.mcuVersion}');
      print('  New BLE Version: $newBleVersion');
      print('  New MCU Version: $newMcuVersion');

      try {
        final updateResponse = await _flaskRepository.updateFlask(
          bleDeviceId: flask.id,
          ledLightMode: isLightMode,
          name: flask.name,
          colorId: selectedColor.colorId,
          volume: flaskVolume,
          wakeUpFromSleepTime: wakeUpFromSleepTime,
          bleVersion: newBleVersion,
          mcuVersion: mcuVersion,
        );

        updateResponse.when(success: (updatedFlask) {
          print('Flask versions updated successfully');
          print('  Final BLE Version: ${updatedFlask.bleVersion}');
          print('  Final MCU Version: ${updatedFlask.mcuVersion}');
          // Update local flask reference
          flask = updatedFlask.toDomain();
          print('flask.bleVersion: ${flask.bleVersion}');
          print('flask.mcuVersion: ${flask.mcuVersion}');
          print('event.mcuVersion: ${event.mcuVersion}');
          print('event.bleVersion: ${event.bleVersion}');

          // Option 3: Update BLE manager with new versions
          final manager = BleManager().getManager(flask);
          if (manager != null) {
            manager.bleVersion = updatedFlask.bleVersion;
            if (updatedFlask.mcuVersion != null) {
              manager.mcuVersion = double.tryParse(updatedFlask.mcuVersion!);

              // Option 1: Create new event with updated versions
              final updatedEvent = FetchFlaskFirmwareVersionEvent(
                mcuVersion: double.tryParse(mcuVersion ?? ''),
                bleVersion: flask.bleVersion,
              );
              print('Updated event.mcuVersion: ${updatedEvent.mcuVersion}');
              print('Updated event.bleVersion: ${updatedEvent.bleVersion}');

              // Dispatch the updated event to trigger second call
              print('🔄 Dispatching updated event for second call...');
              add(updatedEvent);
            } else {
              mcuVersion = _extractVersionFromPath(_mcuPath ?? '');
              print('No MCU version found : _____  mcuPath: $_mcuPath');
              print('No MCU version found : _____  mcuVersion: $mcuVersion');
              final updatedEvent = FetchFlaskFirmwareVersionEvent(
                mcuVersion: double.tryParse(mcuVersion ?? ''),
                bleVersion: flask.bleVersion,
              );
              add(updatedEvent);
            }

            print('Updated BLE manager versions:');
            print('  Manager BLE Version: ${manager.bleVersion}');
            print('  Manager MCU Version: ${manager.mcuVersion}');

            print('event.mcuVersion: ${event.mcuVersion}');
            print('event.bleVersion: ${event.bleVersion}');
          }
        }, error: (error) {
          print('Failed to update Flask versions: $error');
        });
      } catch (e) {
        print('Error updating Flask versions: $e');
      }
    } else {
      print('No version update needed - versions are current');
      print('  Current BLE Version: ${flask.bleVersion}');
      print('  Current MCU Version: ${flask.mcuVersion}');
    }
  }

  // Helper method to extract version from file path
  String? _extractVersionFromPath(String path) {
    try {
      // Extract filename from path
      final uri = Uri.parse(path);
      final filename = uri.pathSegments.last;
      print('Extracting version from filename: $filename');

      // Common version patterns in firmware filenames
      // Examples: "firmware_v1.2.3.bin", "mcu_1.4.7.bin", "v2.1.0_firmware.bin"
      final versionPatterns = [
        RegExp(r'v?(\d+\.\d+\.\d+)'), // v1.2.3 or 1.2.3
        RegExp(r'v?(\d+\.\d+)'), // v1.2 or 1.2
        RegExp(r'v?(\d+)'), // v1 or 1
      ];

      for (final pattern in versionPatterns) {
        final match = pattern.firstMatch(filename.toLowerCase());
        if (match != null) {
          final version = match.group(1);
          print('Extracted version: $version from pattern: ${pattern.pattern}');
          return version;
        }
      }

      print('No version pattern found in filename: $filename');
      return null;
    } catch (e) {
      print('Error extracting version from path $path: $e');
      return null;
    }
  }

  void _scheduleRetry(
    FetchFlaskFirmwareVersionEvent event,
    Emitter<FlaskPersonalizationState> emit,
  ) {
    print('schedule retry');
    _firmwareRetryCount++;
    print(
        'Scheduling retry ${_firmwareRetryCount}/$_maxRetryAttempts in $_retryIntervalSeconds seconds');

    // Emit retrying state to inform UI
    emit(FlaskFirmwareRetryingState(_firmwareRetryCount, _maxRetryAttempts));

    _firmwareRetryTimer?.cancel();
    _firmwareRetryTimer = Timer(Duration(seconds: _retryIntervalSeconds), () {
      add(FetchFlaskFirmwareVersionEvent(
        mcuVersion: event.mcuVersion,
        bleVersion: event.bleVersion,
      ));
    });
  }

  // Add other required methods...
  Future<void> _onSetFlaskDetails(
    SetFlaskDetailEvent event,
    Emitter<FlaskPersonalizationState> emit,
  ) async {
    flask = event.flask;
    flaskVolume = event.flask.flaskVolume;
    wakeUpFromSleepTime = event.flask.wakeUpFromSleepTime;
    isLightMode = event.flask.isLightMode;
    selectedColor = event.flask.color ??
        LedLightColorDomain(LedLightColorEntity(
            1, true, 'AA', ['#FF0000', '#00FF00', '#0000FF']));
    hasInitialized = true;
    emit(FlaskPersonalizationSetState());
  }

  Future<void> _onUpdateFlaskLightMode(
    UpdateFlaskLightMode event,
    Emitter<FlaskPersonalizationState> emit,
  ) async {
    isLightMode = event.isLightMode;
    emit(FlaskPersonalizationSetState());
  }

  Future<void> _onUpdateWakeUpFromSleepTime(
    UpdateFlaskWakeUpFromSleepTime event,
    Emitter<FlaskPersonalizationState> emit,
  ) async {
    wakeUpFromSleepTime = event.seconds;
    emit(FlaskPersonalizationSetState());
  }

  Future<void> _onUpdateFlaskVolume(
    UpdateFlaskVolume event,
    Emitter<FlaskPersonalizationState> emit,
  ) async {
    flaskVolume = event.volume;
    emit(FlaskPersonalizationSetState());
  }

  Future<void> _onUpdateFlaskName(
    UpdateFlaskName event,
    Emitter<FlaskPersonalizationState> emit,
  ) async {
    // Send wake up command first
    await BleManager().sendData(flask, FlaskCommand.wakeUp,
        FlaskCommand.wakeUp.commandData.addingCRC());

    final response =
        await BleManager().sendData(flask, FlaskCommand.updateName, [2]);
    if (response.isNotEmpty) {
      // emit()
    }
    emit(FlaskPersonalizationSetState());
  }

  Future<void> _onUpdateFlaskColor(
    UpdateFlaskColor event,
    Emitter<FlaskPersonalizationState> emit,
  ) async {
    selectedColor = event.color;
    emit(FlaskPersonalizationSetState());
  }

  Future<void> _onUpdateFlask(
    UpdateFlaskRequestEvent event,
    Emitter<FlaskPersonalizationState> emit,
  ) async {
    try {
      emit(FlaskPersonalizationChangingState());

      final response = await _flaskRepository.updateFlask(
        bleDeviceId: event.id,
        ledLightMode: event.isLightMode,
        name: event.name,
        colorId: event.colorId,
        volume: event.volume,
        wakeUpFromSleepTime: wakeUpFromSleepTime,
        bleVersion: event.bleVersion,
        mcuVersion: event.mcuVersion,
      );

      response.when(
        success: (flask) {
          emit(FlaskPersonalizationUpdateCompleteState(
            'Flask updated successfully'.localized,
            event.navigatesBack,
          ));
        },
        error: (error) {
          emit(FlaskPersonalizationApiErrorState(error.toMessage()));
        },
      );
    } catch (e) {
      emit(FlaskPersonalizationApiErrorState(e.toString()));
    }
  }

  Future<void> _onFlaskPersonalizationSettingsEvent(
    FlaskPersonalizationSettingsEvent event,
    Emitter<FlaskPersonalizationState> emit,
  ) async {
    try {
      final response =
          await _flaskRepository.fetchFlaskPersonalizationOptions();
      response.when(
        success: (settings) {
          personalizationSettings = settings;
          emit(FlaskPersonalizationSetState());
        },
        error: (error) {
          emit(FlaskPersonalizationApiErrorState(error.toMessage()));
        },
      );
    } catch (e) {
      emit(FlaskPersonalizationApiErrorState(e.toString()));
    }
  }

  // Additional methods for upgrade paths and data management
  Map<String, dynamic> getUpgradeData() {
    return {
      'flask': flask,
      'cycleNumber': 5, // Default cycle number
    };
  }

  List<Map<String, dynamic>> getAllUpgradeData() {
    return _firmwareResponses
        .map((response) => {
              'blePath': response.blePath,
              'mcuPath': response.mcuPath,
              'imagePaths': response.imagePaths,
              'currentVersion': response.currentVersion,
              'mandatoryVersionCheck': response.mandatoryVersionCheck,
              'mcuVersion': _extractMcuVersionSync(response.mcuPath ?? ''),
            })
        .toList();
  }

  void logStoredUpgradePaths() {
    print('=== Stored Upgrade Paths ===');
    print('BLE Path: $_blePath');
    print('MCU Path: $_mcuPath');
    print('Image Paths: $_imagePaths');
    print('Has upgrades available: $hasUpgradesAvailable');
    print('Total firmware responses: ${_firmwareResponses.length}');
    print('=============================');
  }

  // Method to check if upgrade is available for specific type
  bool hasUpgradeForType(String upgradeType) {
    switch (upgradeType.toLowerCase()) {
      case 'ble':
        return _blePath != null;
      case 'mcu':
        return _mcuPath != null;
      case 'images':
        return _imagePaths.isNotEmpty;
      default:
        return false;
    }
  }

  // Method to clear firmware data
  void clearFirmwareData() {
    firmwareInfo = null;
    firmwareInfoRawResponse = null;
    // Clear all firmware responses array
    _firmwareResponses.clear();
    // Clear upgrade paths
    _blePath = null;
    _mcuPath = null;
    _imagePaths.clear();
    print('Firmware data, all responses array, and upgrade paths cleared');
  }

  // Method to get specific field from raw response
  String? getRawResponseField(String fieldName) {
    final response = completeFirmwareResponse;
    if (response != null && response.containsKey(fieldName)) {
      return response[fieldName]?.toString();
    }
    return null;
  }

  // Debug method to print all stored firmware info
  void logAllFirmwareInfo() {
    print('=== All Firmware Info ===');
    print('Current firmwareInfo: $firmwareInfo');
    print('Raw response: $firmwareInfoRawResponse');
    print('Complete response: $completeFirmwareResponse');
    print('Has complete data: $hasCompleteFirmwareData');
    print('=== Upgrade Paths ===');
    print('BLE Path: $_blePath');
    print('MCU Path: $_mcuPath');
    print('Image Paths: $_imagePaths');
    print('=== Status ===');
    print('Has upgrades available: $hasUpgradesAvailable');
    print('Has BLE upgrade: ${hasUpgradeForType('ble')}');
    print('Has MCU upgrade: ${hasUpgradeForType('mcu')}');
    print('Has Image upgrades: ${hasUpgradeForType('images')}');
    print('=====================================');
  }

  @override
  Future<void> close() async {
    // Clean up timer when bloc is disposed
    _firmwareRetryTimer?.cancel();
    // Clear firmware data
    clearFirmwareData();
    return super.close();
  }
}
