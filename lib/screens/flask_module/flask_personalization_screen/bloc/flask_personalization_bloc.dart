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

  Future<void> _onFetchFlaskFirmwareVersionEvent(
    FetchFlaskFirmwareVersionEvent event,
    Emitter<FlaskPersonalizationState> emit,
  ) async {
    print(
        'onFetchFlaskFirmwareVersionEvent - Attempt ${_firmwareRetryCount + 1}');
    print('mcuVersion: ${event.mcuVersion}');
    print('bleVersion: ${event.bleVersion}');

    final response = await _flaskRepository.fetchFlaskVersion(
        flaskId: flask.serialId,
        mcuVersion: event.mcuVersion,
        bleVersion: event.bleVersion);

    print('flask.bleVersion: ${flask.bleVersion}');
    print('flask.mcuVersion: ${flask.mcuVersion}');
    print('event.mcuVersion: ${event.mcuVersion}');
    print('event.bleVersion: ${event.bleVersion}');

    // Method 1: Simple toString (shows Result wrapper)
    print('=== Response Object ===');
    print('Response toString: ${response.toString()}');
    print('Response type: ${response.runtimeType}');

    // Method 2: Extract actual data using when()
    response.when(success: (data) {
      print('=== SUCCESS Response Data ===');
      print('Success data type: ${data.runtimeType}');
      print('Success data toString: ${data.toString()}');
      print('Success data JSON: ${data.toJson()}');
      print('Current Version: ${data.currentVersion}');
      print('BLE Path: ${data.blePath}');
      print('MCU Path: ${data.mcuPath}');
      // print('MCU Version: ${data.mcuVersion}');
      print('Image Paths: ${data.imagePaths}');
      print('Mandatory Version Check: ${data.mandatoryVersionCheck}');

      // Check if the parsed object has mcu_version
      final parsedJson = data.toJson();
      print('=== Checking for mcu_version ===');
      print('Parsed JSON keys: ${parsedJson.keys.toList()}');
      print(
          'Has mcu_version in parsed: ${parsedJson.containsKey('mcu_version')}');
      if (parsedJson.containsKey('mcu_version')) {
        print('✅ mcu_version value: ${parsedJson['mcu_version']}');
      } else {
        print('❌ mcu_version not found in parsed JSON');
      }
      // print('Direct mcuVersion property: ${data.mcuVersion}');
      print('================================');
      print('============================');
    }, error: (error) {
      print('=== ERROR Response ===');
      print('Error type: ${error.runtimeType}');
      print('Error toString: ${error.toString()}');
      print('==================');
    });

    // Method 3: Alternative pattern matching using map()
    response.map(success: (success) {
      final data = success.body;
      print('=== Map Success Pattern ===');
      print('Success body: $data');
      print('Success JSON: ${data.toJson()}');
      print('==========================');
    }, error: (error) {
      print('=== Map Error Pattern ===');
      print('Error object: ${error.error}');
      print('Error message: ${error.error.toMessage()}');
      print('Error toString: ${error.error.toString()}');
      print('========================');
    });

    // if (kDebugMode) {
    //   response = await _flaskRepository.fetchFlaskVersion(
    //       flaskId: flask.serialId, mcuVersion: 3, bleVersion: '1.4.7');
    // }
    response.when(success: (flaskFirmwareResponse) {
      // Store both raw response and domain object
      firmwareInfoRawResponse = flaskFirmwareResponse;
      firmwareInfo = FlaskFirmwareVersionDomain(flaskFirmwareResponse);

      print('=== Complete Firmware Response ===');
      print('Raw Response: ${firmwareInfoRawResponse?.toJson()}');
      print('Domain Object: ${firmwareInfo}');
      print('================================');

      // Extract and store upgrade paths from the firmware response
      _extractUpgradePaths(flaskFirmwareResponse);

      // Debug: Log the stored upgrade paths
      logStoredUpgradePaths();

      // Update Flask versions if we have new version info
      _updateFlaskVersionsIfNeeded(event, emit);

      // Check if firmware info is complete
      bool isComplete = _isFirmwareInfoComplete(firmwareInfo!);
      print('Firmware info complete: $isComplete');

      if (isComplete || _firmwareRetryCount >= _maxRetryAttempts) {
        // Clear retry timer and reset counter
        _firmwareRetryTimer?.cancel();
        _firmwareRetryCount = 0;
        emit(FlaskFirmwareInfoFetchedState());
      } else {
        // Schedule retry
        _scheduleRetry(event, emit);
      }
    }, error: (error) {
      print('Error fetching firmware version: $error');
      if (_firmwareRetryCount < _maxRetryAttempts) {
        _scheduleRetry(event, emit);
      } else {
        _firmwareRetryTimer?.cancel();
        _firmwareRetryCount = 0;
        // Emit error state or empty firmware info
        emit(FlaskFirmwareInfoFetchedState());
      }
    });
  }

  bool _isFirmwareInfoComplete(FlaskFirmwareVersionDomain firmwareInfo) {
    // Firmware info is complete when we get a valid response from the server
    // This includes cases where:
    // 1. There are upgrades available (has upgrade paths)
    // 2. There are no upgrades available (all paths null - intentional)
    // 3. We have a currentVersion (indicates server responded properly)

    print('=== Checking Firmware Info Completeness ===');
    print('firmwareInfo.hasUpgrade: ${firmwareInfo.hasUpgrade}');
    print('firmwareInfo.currentVersion: ${firmwareInfo.currentVersion}');
    print('firmwareInfo.blePath: ${firmwareInfo.blePath}');
    print('firmwareInfo.mcuPath: ${firmwareInfo.mcuPath}');
    // print('firmwareInfo.mcuVersion: ${firmwareInfo.mcuVersion}');
    print('firmwareInfo.imagePath: ${firmwareInfo.imagePath}');

    // Consider complete if:
    // 1. We have a currentVersion (server responded properly), OR
    // 2. We have at least one upgrade path available, OR
    // 3. All paths are explicitly null (no upgrades available)

    // TODO: Check if this is needed
    // final hasCurrentVersion = firmwareInfo.currentVersion != null &&
    // firmwareInfo.currentVersion!.isNotEmpty;
    // final hasUpgradePaths = firmwareInfo.hasUpgrade;
    final noUpgradePathsExplicit = firmwareInfo.mcuPath == null ||
        (firmwareInfo.imagePath?.isEmpty ?? true);

    final isComplete = noUpgradePathsExplicit;

    // print('Has current version: $hasCurrentVersion');
    // print('Has upgrade paths: $hasUpgradePaths');
    print('firmwareInfo.mcuPath: ${firmwareInfo.mcuPath}');
    print('firmwareInfo.imagePath: ${firmwareInfo.imagePath}');
    print('No upgrade paths (explicit): $noUpgradePathsExplicit');
    print('Is complete: $isComplete');
    print('==========================================');

    return isComplete;
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

    if (newMcuVersion == null && manager != null) {
      newMcuVersion =
          manager.mcuVersion?.toString() ?? event.mcuVersion?.toString();
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
    bool needsUpdate = false;

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
          mcuVersion: newMcuVersion,
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
                mcuVersion: manager.mcuVersion,
                bleVersion: flask.bleVersion,
              );
              print('Updated event.mcuVersion: ${updatedEvent.mcuVersion}');
              print('Updated event.bleVersion: ${updatedEvent.bleVersion}');

              // Dispatch the updated event to trigger second call
              print('🔄 Dispatching updated event for second call...');
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

  Future<void> _onSetFlaskDetails(
    SetFlaskDetailEvent event,
    Emitter<FlaskPersonalizationState> emit,
  ) async {
    flask = event.flask;
    flaskVolume = event.flask.flaskVolume;
    isLightMode = event.flask.isLightMode;
    wakeUpFromSleepTime = event.flask.wakeUpFromSleepTime;
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
    final currentUser = await _userRepository.getCurrentUserId();
    if (currentUser == null) {
      emit(FlaskPersonalizationApiErrorState(
          'user_session_expired_message'.localized));
      Injector.instance<AuthenticationBloc>().add(
          ExpireUserSessionEvent(resetsDevice: true, deleteAccount: false));
      return;
    }
    emit(FlaskPersonalizationChangingState());
    final response = await _flaskRepository.updateFlask(
        bleDeviceId: event.id,
        ledLightMode: event.isLightMode,
        name: event.name,
        colorId: event.colorId,
        volume: event.volume,
        wakeUpFromSleepTime: wakeUpFromSleepTime,
        bleVersion: event.bleVersion,
        mcuVersion: event.mcuVersion);
    response.when(
        success: (updateResponse) {
          emit(FlaskPersonalizationUpdateCompleteState(
              'ProfileEditScreen_profileUpdateSuccess'.localized,
              event.navigatesBack));
        },
        error: (error) {});
  }

  Future<void> _onFlaskPersonalizationSettingsEvent(
    FlaskPersonalizationSettingsEvent event,
    Emitter<FlaskPersonalizationState> emit,
  ) async {
    final response = await _flaskRepository.fetchFlaskPersonalizationOptions();
    response.when(
        success: (flaskPersonalizationSettings) {
          personalizationSettings = flaskPersonalizationSettings;
          emit(FlaskPersonalizationSetState());
        },
        error: (error) {});
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

  /// Get all upgrade data needed for FlaskUpgradeScreen navigation (latest data)
  Map<String, dynamic> getUpgradeData() {
    return {
      'flask': flask,
      'blePath': _blePath,
      'mcuPath': _mcuPath,
      'imagePaths': List<String>.from(_imagePaths),
      'hasUpgrades': hasUpgradesAvailable,
      'cycleNumber': 5, // Default cycle number, can be made configurable
    };
  }

  /// Get all firmware responses data as array of upgrade data
  List<Map<String, dynamic>> getAllUpgradeData() {
    List<Map<String, dynamic>> allUpgradeData = [];

    for (int i = 0; i < _firmwareResponses.length; i++) {
      final response = _firmwareResponses[i];
      allUpgradeData.add({
        'flask': flask,
        'blePath': response.blePath,
        'mcuPath': response.mcuPath,
        'imagePaths': response.imagePaths ?? [],
        // Version information
        'targetVersion': response.currentVersion, // Version we're upgrading TO
        'currentBleVersion': flask?.bleVersion, // Current BLE version on flask
        'currentMcuVersion': flask?.mcuVersion, // Current MCU version on flask
        'hasUpgrades': response.blePath != null ||
            response.mcuPath != null ||
            (response.imagePaths?.isNotEmpty ?? false),
        'cycleNumber': 5,
        'responseIndex': i,
        'totalResponses': _firmwareResponses.length,
      });
    }

    return allUpgradeData;
  }

  /// Helper method to check if specific upgrade types are available
  bool hasUpgradeForType(String type) {
    switch (type.toLowerCase()) {
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

  /// Debug method to log all stored upgrade paths
  void logStoredUpgradePaths() {
    print('=== Stored Upgrade Paths Debug ===');
    print('Total firmware responses: $firmwareResponseCount');
    print('');
    print('=== Latest Paths (Backward Compatibility) ===');
    print('BLE Path: $_blePath');
    print('MCU Path: $_mcuPath');
    print('Image Paths (${_imagePaths.length}): $_imagePaths');
    print('');
    print('=== All Upgrade Data Array ===');
    final allUpgrades = getAllUpgradeData();
    for (int i = 0; i < allUpgrades.length; i++) {
      final upgrade = allUpgrades[i];
      print('Response $i:');
      print('  BLE Path: ${upgrade['blePath']}');
      print('  MCU Path: ${upgrade['mcuPath']}');
      print(
          '  Image Paths (${upgrade['imagePaths'].length}): ${upgrade['imagePaths']}');
      print('  Has Upgrades: ${upgrade['hasUpgrades']}');
      print('');
    }
    print('=== Individual Arrays (for reference) ===');
    print('All BLE Paths (${allBlePaths.length}): $allBlePaths');
    print('All MCU Paths (${allMcuPaths.length}): $allMcuPaths');
    print('All Image Paths (${allImagePaths.length}): $allImagePaths');
    print('');
    print('=== Status ===');
    print('Has upgrades available: $hasUpgradesAvailable');
    print('Has BLE upgrade: ${hasUpgradeForType('ble')}');
    print('Has MCU upgrade: ${hasUpgradeForType('mcu')}');
    print('Has Image upgrades: ${hasUpgradeForType('images')}');
    print('=====================================');
  }

  @override
  Future<void> close() {
    // Clean up timer when bloc is disposed
    _firmwareRetryTimer?.cancel();
    // Clear firmware data
    clearFirmwareData();
    return super.close();
  }
}
