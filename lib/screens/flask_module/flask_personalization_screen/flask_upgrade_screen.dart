import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:convert';
import 'package:flutter_svg/svg.dart';
import 'package:echowater/base/utils/images.dart';
import 'package:echowater/base/constants/string_constants.dart';
import 'package:echowater/screens/flask_module/ota_upgrade_screen/ota_upgrade_screen.dart';
import 'package:echowater/core/domain/domain_models/flask_domain.dart';
import 'package:echowater/base/common_widgets/snackbar/snackbar_style.dart';
import 'package:echowater/base/utils/utilities.dart';
import 'package:echowater/core/injector/injector.dart';
import 'package:echowater/flavor_config.dart';
import 'package:echowater/oc_libraries/ble_service/ble_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:nordic_dfu/nordic_dfu.dart';
import 'package:path/path.dart' as path;
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:echowater/screens/flask_module/ota_upgrade_screen/ble_utils.dart';
import 'package:echowater/screens/flask_module/ota_upgrade_screen/util.dart';
import 'package:echowater/core/api/clients/rest_client/authorized_api_client/authorized_api_client.dart';
import 'package:echowater/core/api/models/flask_firmware_version_data/flask_firmware_version_data.dart';
import 'package:echowater/core/services/firmware_update_log_report_service.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:echowater/core/domain/domain_models/flask_option.dart';
import 'package:flutter/gestures.dart';

/// This screen is used to upgrade the firmware of the flask
/// It can either show a mock upgrade UI or launch the real OTA upgrade

class FlaskUpgradeScreen extends StatefulWidget {
  const FlaskUpgradeScreen({
    super.key,
    this.flask,
    this.cycleNumber,
    this.blePath,
    this.mcuPath,
    this.imageLibraryPaths,
    this.allUpgradeData, // New parameter for all upgrade data
    this.refreshFlaskVersion,
    this.showMockUI = true,
  });

  final FlaskDomain? flask;
  final int? cycleNumber;
  final String? blePath;
  final String? mcuPath;
  final List<String>? imageLibraryPaths;
  final List<Map<String, dynamic>>?
      allUpgradeData; // All firmware responses data
  final void Function(bool)? refreshFlaskVersion;
  final bool showMockUI; // Whether to show mock UI or launch real OTA

  @override
  _FlaskUpgradeScreenState createState() => _FlaskUpgradeScreenState();

  /// Create a route for this screen with all necessary parameters
  static Route<void> route({
    FlaskDomain? flask,
    int? cycleNumber,
    String? blePath,
    String? mcuPath,
    List<String>? imageLibraryPaths,
    List<Map<String, dynamic>>? allUpgradeData, // New parameter
    void Function(bool)? refreshFlaskVersion,
    bool showMockUI = true,
  }) {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/FlaskUpgradeScreen'),
      builder: (_) => FlaskUpgradeScreen(
        flask: flask,
        cycleNumber: cycleNumber,
        blePath: blePath,
        mcuPath: mcuPath,
        imageLibraryPaths: imageLibraryPaths,
        allUpgradeData: allUpgradeData, // Pass the new parameter
        refreshFlaskVersion: refreshFlaskVersion,
        showMockUI: showMockUI,
      ),
    );
  }
}

enum UpdateType {
  ble,
  mcu,
  images;
}

enum UpdateStatus { idle, updating, updateSuccess, updateFailed }

class _FlaskUpgradeScreenState extends State<FlaskUpgradeScreen>
    with TickerProviderStateMixin {
  List<double> progresses =
      []; // Will be initialized dynamically based on allUpgradeData
  int currentVersion = 0;
  Timer? _progressTimer;
  bool isUpdating = false;

  // OTA Progress tracking variables
  String _updateStateText = '';
  UpdateStatus _updateStatus = UpdateStatus.idle;
  UpdateType _updateType = UpdateType.mcu;
  int _cyclesCount = 0;
  bool _onScanSuccess = false;
  int _scanTryCount = 0;
  static const int blockSize = 128;
  bool _hasBaseDisconnected = false;
  bool _hasUpdatedBLE = false;
  bool _hasUpdatedMCU = false;
  List<String> imagePaths = [];
  List<String> successImages = [];
  List<Map<String, dynamic>>? _processedUpgradeData;

  // Real progress tracking
  double _currentItemProgress = 0;
  int _completedItemsCount = 0;
  double _overallProgress = 0;
  int _totalItemsCount = 0;
  bool _isCurrentItemComplete = false;

  // Flask version data tracking
  FlaskFirmwareVersionData? _flaskVersionData;
  bool _isLoadingVersionData = false;
  String? _versionDataError;

  // MCU version tracking
  double? _realTimeMcuVersion;
  bool _isLoadingMcuVersion = false;
  String? _mcuVersionError;

  // API client
  late final AuthorizedApiClient _apiClient;

  // OTA Upgrade utilities
  late final FirmwareUpdateLogReportService _logService;

  // Animation controllers
  late AnimationController _secondProgressAnimationController;
  late AnimationController _thirdProgressAnimationController;
  late Animation<Offset> _secondProgressSlideAnimation;
  late Animation<Offset> _thirdProgressSlideAnimation;
  late Animation<double> _secondProgressFadeAnimation;
  late Animation<double> _thirdProgressFadeAnimation;

  // Animation for moving Next Update button
  late AnimationController _buttonMoveAnimationController;
  late Animation<Offset> _buttonSlideAnimation;
  late Animation<double> _buttonFadeAnimation;

  /// Wake up the flask device before sending other commands
  Future<String> wakeUpFlask() async {
    if (widget.flask == null) {
      print('❌ No flask provided - cannot send wake up command');
      return 'No flask device available';
    }

    try {
      print('📱 Sending wake up command to flask: ${widget.flask!.name}');

      final response = await BleManager().sendData(
        widget.flask!,
        FlaskCommand.wakeUp,
        FlaskCommand.wakeUp.commandData.addingCRC(),
      );

      print('✅ Wake up command sent successfully');

      // Standard delay to let flask wake up
      await Future.delayed(const Duration(milliseconds: 1400));

      return response;
    } catch (e) {
      print('❌ Error sending wake up command: $e');
      return 'Error: $e';
    }
  }

  /// Wake up flask and then send a custom command
  Future<void> wakeUpAndSendCommand(
      FlaskCommand command, List<int> commandData) async {
    if (widget.flask == null) {
      print('❌ No flask provided - cannot send commands');
      return;
    }

    try {
      // Step 1: Wake up flask
      await wakeUpFlask();

      // Step 2: Send your custom command
      print('📱 Sending custom command: ${command.name}');
      await BleManager().sendData(
        widget.flask!,
        command,
        commandData,
      );

      print('✅ Custom command sent successfully');
    } catch (e) {
      print('❌ Error in wake up and send command sequence: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    _cyclesCount = widget.cycleNumber ?? 5;
    imagePaths = widget.imageLibraryPaths ?? [];

    List<Map<String, dynamic>>? processedUpgradeData = widget.allUpgradeData;

    if (widget.allUpgradeData != null) {
      // Step 1: Remove entries with null or empty mcuPath
      final cleanedList = widget.allUpgradeData!
          .where((item) =>
                  item['mcuPath'] != null &&
                  item['mcuPath'].toString().trim().isNotEmpty
              // &&
              // (item['mcuVersion'] == '8.2')
              )
          .toList();

      // Step 2: Deduplicate based on mcuPath, keep the first occurrence
      final seenPaths = <String>{};
      processedUpgradeData = cleanedList.where((item) {
        final mcuPath = item['mcuPath'];
        if (seenPaths.contains(mcuPath)) {
          return false; // duplicate, skip
        } else {
          seenPaths.add(mcuPath);
          return true; // first time, keep it
        }
      }).toList();
    }

    // Store processed data for use in other methods
    _processedUpgradeData = processedUpgradeData;

    // Print all upgrade data in a readable format
    print("=== ALL UPGRADE DATA ===");
    if (processedUpgradeData != null) {
      print("Total responses: ${processedUpgradeData.length}");
      for (int i = 0; i < processedUpgradeData.length; i++) {
        final data = processedUpgradeData[i];
        print("____ mcuPath: ${i} : ${data['mcuPath']}");
      }
    } else {
      print("allUpgradeData is null");
    }
    print(
        "========================= END OF ALL UPGRADE DATA ========================= ");
    print("processedUpgradeData length : ${processedUpgradeData?.length ?? 0}");
    // Process all upgrade data if available
    // Initialize dynamic progress array based on allUpgradeData size
    _initializeDynamicProgressArray();

    _processAllUpgradeData();

    // Initialize API client
    _apiClient = Injector.instance<AuthorizedApiClient>();

    // Initialize logging service
    _logService = Injector.instance<FirmwareUpdateLogReportService>();
    if (widget.flask != null) {
      _logService.startFirmwareUpgradeLogReport(flask: widget.flask!);
      _logService.addFirmwareUpgradeLogReport(log: {
        'type': 'FIRMWARE_UPDATE',
        'message': 'Opened the screen for firmware update',
        'error': false
      });
    }

    // Initialize animation controllers
    _secondProgressAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _thirdProgressAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Setup slide animations (slide down from above)
    _secondProgressSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _secondProgressAnimationController,
      curve: Curves.easeOutBack,
    ));

    _thirdProgressSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _thirdProgressAnimationController,
      curve: Curves.easeOutBack,
    ));

    // Setup fade animations
    _secondProgressFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _secondProgressAnimationController,
      curve: Curves.easeIn,
    ));

    _thirdProgressFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _thirdProgressAnimationController,
      curve: Curves.easeIn,
    ));

    // Initialize button move animation controller
    _buttonMoveAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Setup button slide animation (slide down smoothly)
    _buttonSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _buttonMoveAnimationController,
      curve: Curves.easeOut,
    ));

    // Setup button fade animation
    _buttonFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _buttonMoveAnimationController,
      curve: Curves.easeIn,
    ));

    // _initializeProgress();

    // Fetch flask version data when screen opens
    _fetchFlaskVersionData();

    // Set up MCU version listener
    _setupMcuVersionListener();

    _startProgressTimer();
  }

  /// Process all upgrade data from bloc
  void _processAllUpgradeData() {
    if (widget.allUpgradeData == null || widget.allUpgradeData!.isEmpty) {
      print('📦 No allUpgradeData provided');
      return;
    }

    print('=== FlaskUpgradeScreen: Processing All Upgrade Data ===');
    print('Total upgrade responses: ${widget.allUpgradeData!.length}');

    for (int i = 0; i < widget.allUpgradeData!.length; i++) {
      final upgradeData = widget.allUpgradeData![i];
      print('');
      print('Response $i:');
      print('~  MCU Path: ${upgradeData['mcuPath']}');
      print('~  Image Paths: ${upgradeData['imagePaths']}');
      print('~  MCU Version: ${upgradeData['mcuVersion']}');
    }
    print('================================================');

    // Example: Use the first response data for upgrade
    if (widget.allUpgradeData!.isNotEmpty) {
      final firstUpgrade = widget.allUpgradeData![0];
      print('🚀 Using first upgrade data for upgrade process:');
      print('~  BLE: ${firstUpgrade['blePath']}');
      print('~  MCU: ${firstUpgrade['mcuPath']}');
      print('~  Images: ${firstUpgrade['imagePaths']}');
    }
  }

  /// Initialize dynamic progress array based on allUpgradeData size
  void _initializeDynamicProgressArray() {
    int upgradeCount = 3; // Default to 3 if no allUpgradeData

    if (widget.allUpgradeData != null && widget.allUpgradeData!.isNotEmpty) {
      upgradeCount = _processedUpgradeData!.length;
    }

    print('upgradeCount : $upgradeCount');
    print('widget.showMockUI : ${widget.showMockUI}');

    // Initialize progress array with zeros
    progresses = List.filled(upgradeCount, 0.0);

    print(
        '📊 Initialized $upgradeCount progress bars based on allUpgradeData size');
    print('   Progress array: $progresses');
    print('   Will show progress bars: ${widget.showMockUI}');
  }

  /// Fetches flask version data from API and saves to JSON file
  Future<void> _fetchFlaskVersionData() async {
    if (widget.flask == null) {
      print('⚠️ No flask provided, skipping version data fetch');
      return;
    }

    setState(() {
      _isLoadingVersionData = true;
      _versionDataError = null;
    });

    try {
      print('🔍 Fetching flask version data for flask ID: ${widget.flask!.id}');
      print('   • BLE Version: ${widget.flask!.bleVersion}');
      print('   • MCU Version: ${widget.flask!.mcuVersion}');

      // Convert MCU version to double if it's a string
      double? mcuVersionDouble;
      if (widget.flask!.mcuVersion != null) {
        try {
          mcuVersionDouble = double.parse(widget.flask!.mcuVersion!);
        } catch (e) {
          print(
              '⚠️ Could not parse MCU version as double: ${widget.flask!.mcuVersion}');
          mcuVersionDouble = null;
        }
      }

      final versionData = await _apiClient.fetchFlaskVersion(
        widget.flask!.id,
        mcuVersionDouble,
        widget.flask!.bleVersion,
      );

      setState(() {
        _flaskVersionData = versionData;
        _isLoadingVersionData = false;
      });

      print('✅ Flask version data fetched successfully');
      print('   • Current Version: ${versionData.currentVerion}');
      print('   • BLE Path: ${versionData.blePath}');
      print('   • MCU Path: ${versionData.mcuPath}');
      print('   • Image Paths: ${versionData.imagePaths?.length ?? 0} images');
      print(
          '   • Mandatory Version Check: ${versionData.mandatoryVersionCheck}');

      // Save to JSON file
      // await _saveVersionDataToJsonFile(versionData);
    } catch (e, stackTrace) {
      print('❌ Error fetching flask version data: $e');
      print('Stack trace: $stackTrace');

      setState(() {
        _versionDataError = e.toString();
        _isLoadingVersionData = false;
      });

      if (mounted) {
        Utilities.showSnackBar(
          context,
          'Failed to fetch flask version data: $e',
          SnackbarStyle.error,
        );
      }
    }
  }

  /// Saves flask version data to a JSON file in the documents directory
  Future<void> _saveVersionDataToJsonFile(
      FlaskFirmwareVersionData versionData) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'flask_version_data_${widget.flask!.id}_$timestamp.json';
      final file = File(path.join(directory.path, fileName));

      // Create comprehensive data object including flask info and version data
      final completeData = {
        'timestamp': DateTime.now().toIso8601String(),
        'flask_info': {
          'id': widget.flask!.id,
          'serial_id': widget.flask!.serialId,
          'name': widget.flask!.name,
          'current_ble_version': widget.flask!.bleVersion,
          'current_mcu_version': widget.flask!.mcuVersion,
          'volume': widget.flask!.flaskVolume,
          'is_paired': widget.flask!.isPaired,
          'is_light_mode': widget.flask!.isLightMode,
          'wake_up_from_sleep_time': widget.flask!.wakeUpFromSleepTime,
        },
        'version_data': versionData.toJson(),
        'screen_params': {
          'cycle_number': widget.cycleNumber,
          'ble_path': widget.blePath,
          'mcu_path': widget.mcuPath,
          'image_library_paths': widget.imageLibraryPaths,
          'show_mock_ui': widget.showMockUI,
        }
      };

      const encoder = JsonEncoder.withIndent('  ');
      final jsonString = encoder.convert(completeData);

      await file.writeAsString(jsonString);

      print('✅ Flask version data saved to: ${file.path}');
      print('📄 File size: ${await file.length()} bytes');

      // if (mounted) {
      //   Utilities.showSnackBar(
      //     context,
      //     'Flask version data saved to: $fileName',
      //     SnackbarStyle.success,
      //   );
      // }
    } catch (e, stackTrace) {
      print('❌ Error saving flask version data to file: $e');
      print('Stack trace: $stackTrace');

      if (mounted) {
        Utilities.showSnackBar(
          context,
          'Failed to save version data: $e',
          SnackbarStyle.error,
        );
      }
    }
  }

  void _initializeProgress() {
    _currentItemProgress = 0.0;
    _completedItemsCount = 0;
    _overallProgress = 0.0;
    _isCurrentItemComplete = false;

    // Count total items at initialization
    // For testing purposes, always include at least one of each type even if paths are not provided
    _totalItemsCount = 0;

    //HOVO when need to update ble Path too

    // _totalItemsCount += 1; // Always include BLE update for simulation
    _totalItemsCount += 1; // Always include MCU update for simulation

    ///HOVO percents need to change 2 when activate ipage Path too
    print('~~~~~~~~~ imagePaths.length: ${imagePaths.length}');
    final List<dynamic> imageListForCurrent =
        (_processedUpgradeData![currentVersion]['imagePaths'] as List?) ??
            const [];
    _totalItemsCount += imageListForCurrent.isNotEmpty
        ? imageListForCurrent.length
        : 0; // At least 1 image for simulation

    print('📊 Progress Initialization: Total Items = $_totalItemsCount');
  }

  void _calculateProgressAndShow({required int percentage}) {
    // Convert the percentage to a decimal value between 0.0 and 1.0
    _currentItemProgress = percentage / 100.0;

    // Ensure we always have at least 1 item to prevent division by zero
    if (_totalItemsCount == 0) {
      _totalItemsCount = 1; // Default to 3 items (BLE + MCU + 1 Image)
      print('⚠️ Total items was 0, setting to default: $_totalItemsCount');
    }

    // Check if the current item is complete
    final wasComplete = _isCurrentItemComplete;
    _isCurrentItemComplete = percentage >= 100;

    // If the item just completed, increment the counter
    if (_isCurrentItemComplete && !wasComplete) {
      _completedItemsCount++;
    }

    // Calculate the weight of each item as a decimal
    final itemWeight = 1.0 / _totalItemsCount;

    // Calculate cumulative progress
    var calculatedProgress = _completedItemsCount * itemWeight;

    // Add current item's progress only if it's not counted as complete yet
    if (!_isCurrentItemComplete) {
      calculatedProgress += _currentItemProgress * itemWeight;
    }

    // Special case: only show 100% when all items are truly complete
    if (calculatedProgress >= 0.99 && _completedItemsCount < _totalItemsCount) {
      // Cap at 99% until everything is done
      _overallProgress = 0.99;
    } else {
      _overallProgress = calculatedProgress.clamp(0.0, 1.0);
    }

    // Update the version-specific progress
    if (mounted) {
      setState(() {
        progresses[currentVersion] = _overallProgress;
      });
    }

    // Display percentage with careful rounding
    final displayPercentage = (_overallProgress * 100).toStringAsFixed(1);

    if (kDebugMode) {
      print(
          'Flask Upgrade Percentage log: ${_updateType.name} and percentage: $percentage, ' +
              'Overall: $displayPercentage%, ' +
              'Completed: $_completedItemsCount/$_totalItemsCount');
    }

    // If all items are complete, ensure we show 100%
    if (_completedItemsCount == _totalItemsCount) {
      _overallProgress = 1.0;
      setState(() {
        progresses[currentVersion] = 1.0;
      });
      if (kDebugMode) {
        print(
            'Flask Upgrade Percentage log: All items complete, Overall: 100%');
      }
    }

    // If this item is complete and we're moving to the next one, reset the current progress
    if (_isCurrentItemComplete && _updateType.name != 'COMPLETE') {
      _isCurrentItemComplete = false;
      _currentItemProgress = 0.0;
    }
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    _secondProgressAnimationController.dispose();
    _thirdProgressAnimationController.dispose();
    _buttonMoveAnimationController.dispose();
    WakelockPlus.disable();
    _disposeBLEUtil();

    // Clean up MCU version listener
    BleManager().onFlaskMCURead = null;

    super.dispose();
  }

  void _startProgressTimer() {
    isUpdating = true;
    // Animate button appearance when starting a new version
    _buttonMoveAnimationController.forward();

    // Start the real OTA upgrade instead of mock timer
    if (widget.showMockUI) {
      // Use mock progress for demonstration
      _progressTimer =
          Timer.periodic(const Duration(milliseconds: 10), (timer) {
        setState(() {
          // Increment progress by 0.01 every 100ms (completes in ~10 seconds)
          if (progresses[currentVersion] < 1.0) {
            progresses[currentVersion] += 0.1;

            // Ensure we don't exceed 1.0
            if (progresses[currentVersion] > 1.0) {
              progresses[currentVersion] = 1.0;
            }
          } else {
            // Current version is complete, stop timer and wait for user input
            timer.cancel();
            isUpdating = false;

            // If this is the final version, mark as complete
            if (currentVersion >= progresses.length - 1) {
              isUpdating = false;
            }
          }
        });
      });
    } else {
      // Use real OTA upgrade
      onUpgradeButtonClick();
    }
  }

  void _pauseResumeUpdate() {
    setState(() {
      if (isUpdating) {
        _progressTimer?.cancel();
        isUpdating = false;
      } else {
        _startProgressTimer();
      }
    });
  }

  void _resetProgress() {
    setState(() {
      _progressTimer?.cancel();
      progresses = List.filled(progresses.length, 0.0);
      currentVersion = 0;
      isUpdating = false;
    });

    // Reset button animation
    _buttonMoveAnimationController.reset();

    // Restart the timer after reset
    _startProgressTimer();
  }

  void _startNextUpdate() {
    if (currentVersion < progresses.length - 1 &&
        progresses[currentVersion] >= 1.0) {
      // Animate button disappearing
      _buttonMoveAnimationController.reset();
      setState(() {
        _progressTimer?.cancel();
        currentVersion++;
        progresses[currentVersion] = 0.01; // Start next version
      });
      _startProgressTimer(); // Restart timer for next version with new button position
    }
  }

  void _handleNextUpdateOrResume() {
    _hasUpdatedMCU = false;
    _hasUpdatedBLE = false;

    // Only call refreshFlaskVersion if we actually completed an upgrade
    if (progresses[currentVersion] >= 1.0) {
      widget.refreshFlaskVersion?.call(true);
    }

    print(
        '~~~~~~~~~ refreshFlaskVersion.mcuVersion: ${widget.flask?.mcuVersion} ~~~~~~~~~~ ');
    print(
        '~~~~~~~~~ refreshFlaskVersion.bleVersion: ${widget.flask?.bleVersion} ~~~~~~~~~~ ');
    print(
        '~~~~~~~~~ refreshFlaskVersion.mcuVersion: ${widget.flask?.mcuVersion} ~~~~~~~~~~ ');

    // Only send log report if we have valid version info
    if (widget.flask?.mcuVersion != null && widget.flask?.bleVersion != null) {
      try {
        _logService.sendFirmwareUpgradeLogReport(
            mcuVersion: widget.flask?.mcuVersion,
            bleVersion: widget.flask?.bleVersion);
      } catch (e) {
        print('⚠️ Error sending firmware upgrade log: $e');
        // Don't block UI for logging errors
      }
    }

    if (progresses[currentVersion] >= 1.0 &&
        currentVersion < progresses.length - 1) {
      // Current progress is complete, start next update
      _startNextUpdate();
    } else if (!isUpdating && progresses[currentVersion] < 1.0) {
      // Current progress is paused, resume it
      if (widget.showMockUI) {
        _pauseResumeUpdate();
      } else {
        // Start real OTA upgrade for next version
        onUpgradeButtonClick();
      }
    }
  }

  Widget _buildAnimatedNextUpdateButton() {
    bool isCurrentComplete = progresses[currentVersion] >= 1.0;
    bool canProceed =
        isCurrentComplete && currentVersion < progresses.length - 1;
    bool isUpgradeInProgress = _updateStatus == UpdateStatus.updating;
    bool hasMcuVersion = (getCurrentMcuVersion() != 'Unknown' &&
        getCurrentMcuVersion() ==
            _processedUpgradeData![currentVersion]['mcuVersion']);

    return SlideTransition(
      position: _buttonSlideAnimation,
      child: FadeTransition(
        opacity: _buttonFadeAnimation,
        child: Column(
          children: [
            const SizedBox(height: 8),

            // Show update state text if updating
            if (isUpgradeInProgress && _updateStateText.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  _updateStateText,
                  style: TextStyle(
                    fontFamily: StringConstants.golosFont,
                    fontSize: 12,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withOpacity(0.8),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: (canProceed && !isUpgradeInProgress)
                    //  && hasMcuVersion) ---- HOVO
                    ? _handleNextUpdateOrResume
                    : null,
                child: Text(
                  "Next Update",
                  style: TextStyle(
                    fontFamily: StringConstants.golosFont,
                    fontSize: 14,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w600,
                    height: 1, // Proper line height for button text
                    letterSpacing: 0.28,
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.resolveWith<Color>((states) {
                    if (states.contains(MaterialState.disabled)) {
                      return Colors.grey; // disabled background color
                    }
                    return Colors.white; // enabled background color
                  }),
                  foregroundColor:
                      MaterialStateProperty.resolveWith<Color>((states) {
                    if (states.contains(MaterialState.disabled)) {
                      return Colors.black; // disabled text color
                    }
                    return Colors.black; // enabled text color
                  }),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  /// Build dynamic progress bars based on allUpgradeData size
  List<Widget> _buildDynamicProgressBars() {
    List<Widget> progressWidgets = [];

    for (int i = 0; i < progresses.length; i++) {
      // Generate version label from allUpgradeData or use default
      String versionLabel = _getVersionLabel(i);

      // Add progress bar
      progressWidgets.add(_buildProgressBar(versionLabel, i));

      // Add next update button if this is the current version
      if (currentVersion == i && currentVersion < progresses.length - 1) {
        progressWidgets.add(_buildAnimatedNextUpdateButton());
      }
    }

    return progressWidgets;
  }

  String getMCUVersion(String mcuURL) {
    // Handle empty or invalid URL
    if (mcuURL.isEmpty) {
      print('MCU URL is empty, returning empty string');
      return "";
    }

    // Step 1: Extract filename from URL
    final filename =
        mcuURL.split('/').last; // e.g. MCU_OTA_OfficialVersionV5_0.bin
    print('filename: $filename');
    print('mcuURL: $mcuURL');

    // Step 2: Extract version using RegExp
    final versionMatch = RegExp(r'V(\d+_\d+)').firstMatch(filename);
    if (versionMatch != null && versionMatch.group(1) != null) {
      final versionUnderscore = versionMatch.group(1)!; // e.g. "5_0"
      final versionDot = versionUnderscore.replaceAll('_', '.'); // "5.0"

      print('Version (dot format): $versionDot');

      // Optional: use or return the version
      return versionDot;
    } else {
      print('Version not found in filename');
      return "";
    }
  }

  /// Get version label for progress bar
  String _getVersionLabel(int index) {
    if (_processedUpgradeData != null &&
        _processedUpgradeData!.isNotEmpty &&
        index < _processedUpgradeData!.length) {
      final upgradeData = _processedUpgradeData![index];

      // Create descriptive label based on what upgrades are available
      List<String> upgradeTypes = [];
      if (upgradeData['blePath'] != null) upgradeTypes.add('BLE');
      if (upgradeData['mcuPath'] != null) upgradeTypes.add('MCU');
      if (upgradeData['imagePaths'] != null &&
          upgradeData['imagePaths'].isNotEmpty) upgradeTypes.add('Images');

      // Use target version if available, otherwise extract from MCU path
      String versionText = upgradeData['mcuVersion'] ?? 'Unknown';
      // if (upgradeData['currentMcuVersion'] != null) {
      //   versionText = upgradeData['currentMcuVersion'];
      // } else if (upgradeData['currentBleVersion'] != null) {
      //   versionText = upgradeData['currentBleVersion'];
      // }

      if (upgradeTypes.isNotEmpty) {
        return "$versionText (${upgradeTypes.join(', ')})";
      } else {
        return versionText;
      }
    }
    return ""; // Fallback return
  }

  /// Check if all progress is complete
  bool _isAllProgressComplete() {
    if (progresses.isEmpty) return false;
    return currentVersion >= progresses.length - 1 && progresses.last >= 1.0;
  }

  /// Build MCU version information widget
  Widget _buildMcuVersionInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade700, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'MCU Version',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: StringConstants.golosFont,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                onPressed:
                    _isLoadingMcuVersion ? null : _requestMcuVersionViaBLE,
                icon: _isLoadingMcuVersion
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Icon(
                        Icons.refresh,
                        color: Colors.white,
                        size: 20,
                      ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Current: ${getCurrentMcuVersion()}',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontFamily: StringConstants.golosFont,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          if (_mcuVersionError != null) ...[
            const SizedBox(height: 4),
            Text(
              'Error: $_mcuVersionError',
              style: TextStyle(
                color: Colors.red.shade400,
                fontFamily: StringConstants.golosFont,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProgressBar(String versionLabel, int index) {
    bool isActive = index == currentVersion;
    bool isCompleted = progresses[index] >= 1.0;
    bool isDisabled = index > currentVersion || (isUpdating && !isActive);
    bool isUpgradeInProgress =
        _updateStatus == UpdateStatus.updating && isActive;

    return Opacity(
      opacity: isDisabled ? 0.5 : 1.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Version $versionLabel',
            style: TextStyle(
              color: isDisabled ? Colors.grey : Colors.white.withOpacity(0.8),
              fontFamily: StringConstants.golosFont,
              fontSize: 16,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w500,
              height: 1.3, // 130% = 20.8 / 16 = 1.3
              letterSpacing: 0.48,
            ),
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progresses[index],
            backgroundColor: Colors.grey.shade800,
            valueColor: AlwaysStoppedAnimation<Color>(isActive && !isDisabled
                ? (isUpgradeInProgress
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.8)
                    : Theme.of(context).colorScheme.primary)
                : isCompleted
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey),
            minHeight: 8,
            borderRadius: BorderRadius.circular(20),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '${(progresses[index] * 100).toInt()}% complete',
                style: TextStyle(
                  color: isDisabled ? Colors.grey : Colors.white,
                  fontFamily: StringConstants.golosFont,
                  fontSize: 12,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w500,
                  height: 1.3, // 130% = 20.8 / 16 = 1.3
                  letterSpacing: 0.36,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF231F20),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Firmware Update',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: StringConstants.golosFont,
                              fontSize: 28,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w500,
                              height: 1.12,
                              letterSpacing: 0.42,
                            ),
                          ),
                          Text(
                            widget.flask?.name ?? 'Flask',
                            style: TextStyle(
                              color: Colors.grey,
                              fontFamily: StringConstants.golosFont,
                              fontSize: 12,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w500,
                              height: 1.3, // 130% = 20.8 / 16 = 1.3
                              letterSpacing: 0.36,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Show dynamic progress bars based on allUpgradeData size
                          if (widget.allUpgradeData != null &&
                              widget.allUpgradeData!.isNotEmpty) ...[
                            ..._buildDynamicProgressBars(),
                            Center(
                              child: Text(
                                _isAllProgressComplete()
                                    ? "FIRMWARE UPDATE: COMPLETE"
                                    : "FIRMWARE UPDATE: IN PROGRESS",
                                style: TextStyle(
                                    fontFamily: StringConstants.golosFont,
                                    fontSize: 14,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w500,
                                    height: 1.35, // 130% = 20.8 / 16 = 1.3
                                    letterSpacing: 0.42,
                                    color: Colors.white),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],

                          // MCU Version Info Widget
                          _buildMcuVersionInfo(),
                          const SizedBox(height: 20),

                          Container(
                            padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFD875),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SvgPicture.asset(
                                  Images.vectorIcon,
                                  width: 24,
                                  height: 21,
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  "Keep your phone unlocked during the firmware update",
                                  style: TextStyle(
                                    fontFamily: StringConstants.golosFont,
                                    color: Colors.black,
                                    fontSize: 22,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w600,
                                    height: 1.12,
                                    letterSpacing: 0.33,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  "To avoid issues, please keep the app open, your phone unlocked, and your flask near your phone until the update is complete.",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: StringConstants.golosFont,
                                    fontSize: 16,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w500,
                                    height: 1.3, // 130% = 20.8 / 16 = 1.3
                                    letterSpacing: 0.42,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (_isAllProgressComplete()) ...[
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                // Only call refreshFlaskVersion and log if upgrade is complete
                                if (_isAllProgressComplete()) {
                                  widget.refreshFlaskVersion?.call(true);

                                  if (widget.flask?.mcuVersion != null &&
                                      widget.flask?.bleVersion != null) {
                                    try {
                                      _logService.sendFirmwareUpgradeLogReport(
                                          mcuVersion: widget.flask?.mcuVersion,
                                          bleVersion: widget.flask?.bleVersion);
                                    } catch (e) {
                                      print(
                                          '⚠️ Error sending firmware upgrade log: $e');
                                    }
                                  }
                                }
                                print(
                                    '~~~~~~~~~ refreshFlaskVersion.mcuVersion: ${widget.flask?.mcuVersion} ~~~~~~~~~~ ');
                                print(
                                    '~~~~~~~~~ refreshFlaskVersion.bleVersion: ${widget.flask?.bleVersion} ~~~~~~~~~~ ');
                                Navigator.of(context)
                                    .pop(); // Go back to previous screen
                              },
                              child: Text(
                                "Finish",
                                style: TextStyle(
                                  fontFamily: StringConstants.golosFont,
                                  fontSize: 16,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w600,
                                  height:
                                      1.2, // Proper line height for button text
                                  letterSpacing: 0.32,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _setUpdateState(String tips) {
    _updateStateText = tips;
    _updateAllState();
  }

  void _updateAllState() {
    if (mounted) {
      setState(() {});
    }
  }

  void _onFirmwareUpdateIssueLog(String log) {
    if (log.isNotEmpty) {
      BleManager().onNewLog?.call([], 'Firmware Update', true, log, false);
    }
    _setUpdateState(
        'There seems to be some problem updating the firmware. Please try again.');
  }

  void _startScanTry() {
    _scanTryCount = 5;
    _startScan();
  }

  Future<void> _startScan() async {
    final serialId = widget.flask?.appBleModelDevice?.bleDevice.remoteId.str ??
        widget.flask?.serialId;
    if (widget.flask?.appBleModelDevice == null) {
      _logService.addFirmwareUpgradeLogReport(log: {
        'type': 'FIRMWARE_UPDATE',
        'message': 'Firmware Update Failed',
        'error': true,
        'additional_info': {
          'message':
              'Somehow the Flask doesnt have the app ble model will be using flask serial id',
        }
      });
      print("~~~~~~~~~ FIRMWARE UPDATE FAILED ~~~~~~~~~");
    }
    await bleUtil.checkBleState(context, () async {
      _updateStatus = UpdateStatus.updating;
      _onScanSuccess = false;
      _setUpdateState('Firmware upgrade in progress. Please wait...');
      await bleUtil.startScan(listener: (r) async {
        var isFilter = false;
        final mac = serialId?.replaceAll(':', '').toUpperCase() ?? '';
        if (mac.isNotEmpty) {
          print("r.device.remoteId.str: ${r.device.remoteId.str}");
          print("r.device.advName: ${r.device.advName}");
          final rMac = r.device.remoteId.str.replaceAll(':', '').toUpperCase();
          if (rMac.contains(mac)) {
            isFilter = true;
          }
        }
        if (isFilter) {
          _onScanSuccess = true;
          await bleUtil.stopScan();
          print('~~~~~~~~~ _updateType line: 1100: $_updateType');
          if (_updateType == UpdateType.ble) {
            await _doFirmwareUpgrade(r.device);
          } else if (_updateType == UpdateType.mcu) {
            await _updateMcuWithDevice(r.device);
          } else if (_updateType == UpdateType.images) {
            await _updatePicsWithDevice(r.device);
          }
        }
      });
      if (!_onScanSuccess) {
        if (_scanTryCount <= 0) {
          _cyclesCount = _cyclesCount - 1;
          if (_cyclesCount > 0) {
            await _startScan();
          } else {
            _logService.addFirmwareUpgradeLogReport(log: {
              'type': 'FIRMWARE_UPDATE',
              'message': 'Firmware Update Failed',
              'error': true,
              'additional_info': {
                'message': "Somehow the Flask's device was not found at all",
              }
            });
            print(
                "~~~~~~~~~ FIRMWARE UPDATE FAILED ~~~~~~~~~ Device not found that needs the update");
            showToast(context, 'Device not found that needs the update');
            await _onFullFirmwareUpdateCompleted(isSuccess: false);
          }
        } else {
          _scanTryCount = _scanTryCount - 1;
          await _startScan();
        }
      }
    });
  }

  Future<Uint8List?> _downloadFileAsBytes(String fileUrl) async {
    try {
      final response = await http.get(Uri.parse(fileUrl));

      if (response.statusCode == 200) {
        // The file is successfully fetched as bytes
        return response.bodyBytes;
      } else {
        print('Failed to download file: ${response.statusCode}');
      }
    } catch (e) {
      print('Error downloading file: $e');
    }

    return null;
  }

  /// Real MCU update method with device parameter
  Future _updateMcuWithDevice(BluetoothDevice device) async {
    print('🟠 MCU FIRMWARE UPGRADE STARTED');
    _setUpdateState('Starting MCU firmware upgrade...');

    _logService.addFirmwareUpgradeLogReport(log: {
      'type': 'FIRMWARE_UPDATE',
      'message':
          'MCU Module Upgrade Started. Will start searching and connecting',
      'error': false,
      'additional_info': {
        'device advertising address': device.advName,
      }
    });

    // Use allUpgradeData for current upgrade
    String? mcuUpgradePath;
    if (_processedUpgradeData != null &&
        _processedUpgradeData!.isNotEmpty &&
        currentVersion < _processedUpgradeData!.length) {
      print("currentVersion: $currentVersion");
      print(
          "mcuUpgradePath: ${_processedUpgradeData![currentVersion]['mcuPath']}");
      mcuUpgradePath = _processedUpgradeData![currentVersion]['mcuPath'];
    } else {
      print(
          "mcuUpgradePath: ${_processedUpgradeData![currentVersion]['mcuPath']}");
      mcuUpgradePath = _processedUpgradeData![currentVersion]['mcuPath'];
    }

    if (mcuUpgradePath == null) {
      print('❌ No MCU upgrade path available');
      await _onMcuUpdateFailed();
      return;
    }

    await bleUtil.connect(context, device, (suc) async {
      if (suc) {
        print("mcuUpgradePath: $mcuUpgradePath");
        //  final file = File(mcuUpgradePath!);

        final upgradeFile = await _downloadFileAsBytes(mcuUpgradePath!);

        if (upgradeFile != null) {
          print(
              'File downloaded successfully. Byte length: ${upgradeFile.length}');
          // You can now use the bytes (e.g. save to file, parse, etc.)
        } else {
          print('Failed to download the file.');
          await _onMcuUpdateFailed();
        }

        // final upgradeFile = await file.readAsBytes();

        final startMcu = await bleUtil.writeWait(
            Uint8List.fromList(
                [0x55, 0xAA, 0x33, 0xCC, 0x11, 0x1E, 0x1F, 0xF1]),
            12);

        Util.v('startMcu:${Util.getHexString(startMcu)}');
        await Future.delayed(const Duration(seconds: 1));
        final blockCount = (upgradeFile!.length.toDouble() / blockSize).ceil();

        print("blockCount: $blockCount");

        _logService.addFirmwareUpgradeLogReport(log: {
          'type': 'FIRMWARE_UPDATE',
          'message': 'MCU Module Upgrade Started And Device Connected',
          'error': false,
          'additional_info': {
            'Block Count': blockCount,
          }
        });

        for (var i = 0; i < blockCount; i++) {
          final block = upgradeFile.sublist(
              i * blockSize, min((i + 1) * blockSize, upgradeFile.length));
          final data = await bleUtil.sendBlock(
              bleUtil.getBlockCmd(
                  block,
                  true,
                  Uint8List.fromList([0x00, 0x00, 0x00, 0x01]),
                  blockCount,
                  i + 1),
              1);
          final percent =
              (((i + 1).toDouble() / blockCount.toDouble()) * 100).toInt();
          print("percent: $percent");
          // progresses[currentVersion] =
          //     ((i + 1).toDouble() / blockCount.toDouble());

          print("progress current version: ${progresses[currentVersion]}");

          final successData = bleUtil.getBlockCmd(
              Uint8List.fromList([0x01]),
              true,
              Uint8List.fromList([0x00, 0x00, 0x00, 0x01]),
              blockCount,
              i + 1);

          // print("i: $i");
          // print("data: ${Util.getHexString(data)}");
          // print("successData: ${Util.getHexString(successData)}");
          // print("areEqual: ${Util.areUint8ListsEqual(data, successData)}");

          if (Util.areUint8ListsEqual(data, successData)) {
            if (i + 1 == blockCount) {
              _logService.addFirmwareUpgradeLogReport(log: {
                'type': 'FIRMWARE_UPDATE',
                'message': 'MCU Module Upgrade Succeeded And Completed',
                'error': false,
              });
              _calculateProgressAndShow(percentage: percent);
              _setUpdateState('MCU firmware update completed!');
              unawaited(_onMCUUpdated());
              return;
            }

            _logService.addFirmwareUpgradeLogReport(log: {
              'type': 'FIRMWARE_UPDATE',
              'message': 'MCU Module Upgrade In Progress',
              'error': false,
              'additional_info': {'Percentage': '$percent%', 'Block Index': i}
            });
            _setUpdateState('MCU firmware upload: $percent%');
            _calculateProgressAndShow(percentage: percent);
          } else {
            _logService.addFirmwareUpgradeLogReport(log: {
              'type': 'FIRMWARE_UPDATE',
              'message': 'MCU Module Upgrade Failed.',
              'error': true,
              'additional_info': {'Percentage': '$percent%', 'Block Index': i}
            });
            await _onMcuUpdateFailed();
            break;
          }
        }
      } else {
        _logService.addFirmwareUpgradeLogReport(log: {
          'type': 'FIRMWARE_UPDATE',
          'message':
              'MCU Module Upgrade Failed. Searching and connecting failed',
          'error': true,
          'additional_info': {
            'device advertising address': device.advName,
          }
        });
        await _onMcuUpdateFailed();
      }
    });
  }

  /// Real image update method with device parameter
  Future _updatePicsWithDevice(BluetoothDevice device) async {
    print('🟢 IMAGE LIBRARY UPGRADE STARTED');
    _setUpdateState('Starting image library upgrade...');

    _logService.addFirmwareUpgradeLogReport(log: {
      'type': 'FIRMWARE_UPDATE',
      'message': 'Image update started',
      'error': false,
      'additional_info': {
        'device': device.advName,
      }
    });
    await bleUtil.connect(context, device, (suc) async {
      if (suc) {
        var imgSuccessCount = 0;
        successImages = [];

        _logService.addFirmwareUpgradeLogReport(log: {
          'type': 'FIRMWARE_UPDATE',
          'message': 'Image update started and device was found',
          'error': false
        });
        for (var k = 0; k < imagePaths.length; k++) {
          print('~~~~~~~~~ imagePaths[k]: ${imagePaths[k]}');
          final upgradeFile = await _downloadFileAsBytes(imagePaths[k]);
          final startPics = await bleUtil.writeWait(
              Uint8List.fromList(
                  [0x55, 0xAA, 0x46, 0x4D, 0x44, 0x49, 0x41, 0x50]),
              3);
          Util.v('startPics:${Util.getHexString(startPics)}');
          final blockCount =
              (upgradeFile!.length.toDouble() / blockSize).ceil();
          print('~~~~~~~~~ blockCount image update: $blockCount');

          for (var i = 0; i < blockCount; i++) {
            _logService.addFirmwareUpgradeLogReport(log: {
              'type': 'FIRMWARE_UPDATE',
              'message': 'Image Upgrade in progress',
              'error': false,
              'additional_info': {
                'image number': k,
                'block count': blockCount,
                'current blocl': i
              }
            });

            final block = upgradeFile.sublist(
                i * blockSize, min((i + 1) * blockSize, upgradeFile.length));
            final data = await bleUtil.sendBlock(
                bleUtil.getBlockCmd(
                    block,
                    false,
                    Util.hex4ToUint8List(
                        path.basenameWithoutExtension(imagePaths[k])),
                    blockCount,
                    i + 1),
                1);
            final percent =
                (((i + 1).toDouble() / blockCount.toDouble()) * 100).toInt();
            _setUpdateState('Image firmware upload: $percent%');

            final successData = bleUtil.getBlockCmd(
                Uint8List.fromList([0x01]),
                false,
                Util.hex4ToUint8List(
                    path.basenameWithoutExtension(imagePaths[k])),
                blockCount,
                i + 1);
            if (Util.areUint8ListsEqual(data, successData)) {
              _calculateProgressAndShow(percentage: percent);
              if (i + 1 == blockCount) {
                imgSuccessCount = imgSuccessCount + 1;
                successImages.add(imagePaths[k]);
              }
            } else {
              break;
            }
          }
        }
        if (imgSuccessCount == imagePaths.length) {
          _logService.addFirmwareUpgradeLogReport(log: {
            'type': 'FIRMWARE_UPDATE',
            'message': 'All Image upgrade success',
            'error': false,
            'additional_info': {
              'success images': successImages,
            }
          });
          unawaited(_onImageUpdateCompleted());
          return;
        } else {
          _logService.addFirmwareUpgradeLogReport(log: {
            'type': 'FIRMWARE_UPDATE',
            'message': 'Some Image update failed',
            'error': true,
            'additional_info': {
              'success images': successImages,
            }
          });
          imagePaths.removeWhere((item) => successImages.contains(item));
          unawaited(_onImageLibraryUpdateFailed());
        }
      } else {
        _logService.addFirmwareUpgradeLogReport(log: {
          'type': 'FIRMWARE_UPDATE',
          'message': 'Image update failed',
          'error': true,
          'additional_info': {
            'message': 'Connecting to device not successful',
          }
        });
        unawaited(_onImageLibraryUpdateFailed());
      }
    });
  }

  Future _doFirmwareUpgrade(BluetoothDevice device) async {
    print('🔷 BLE FIRMWARE UPGRADE STARTED');
    _setUpdateState('Starting BLE firmware upgrade...');

    // Reset progress for this specific update
    _currentItemProgress = 0.0;
    _isCurrentItemComplete = false;

    // Start device scanning and connection
    await _startScanAndUpgrade();
  }

  Future _doFirmwareUpgradeWithDevice(BluetoothDevice device) async {
    _logService.addFirmwareUpgradeLogReport(log: {
      'type': 'FIRMWARE_UPDATE',
      'message': 'BLE Module Upgrade Started',
      'error': false,
      'additional_info': {
        'device advertising address': device.advName,
      }
    });

    try {
      // Use allUpgradeData for current upgrade
      String? bleUpgradePath;
      if (widget.allUpgradeData != null &&
          widget.allUpgradeData!.isNotEmpty &&
          currentVersion < widget.allUpgradeData!.length) {
        bleUpgradePath = widget.allUpgradeData![currentVersion]['blePath'];
      } else {
        bleUpgradePath = widget.blePath;
      }

      if (bleUpgradePath == null) {
        print('❌ No BLE upgrade path available');
        await _onBLEUpdateFailed();
        return;
      }

      await NordicDfu().startDfu(
        device.remoteId.str,
        bleUpgradePath,
        onProgressChanged: (
          deviceAddress,
          percent,
          speed,
          avgSpeed,
          currentPart,
          partsTotal,
        ) {
          _logService.addFirmwareUpgradeLogReport(log: {
            'type': 'FIRMWARE_UPDATE',
            'message': 'BLE Module Upgrade In Progress',
            'error': false,
            'additional_info': {
              'progress percentage': percent.toStringAsFixed(0),
            }
          });
          _setUpdateState(
              'BLE firmware upload: ${percent.toStringAsFixed(1)}%');
          _calculateProgressAndShow(percentage: percent);
        },
        onDfuCompleted: (address) {
          _logService.addFirmwareUpgradeLogReport(log: {
            'type': 'FIRMWARE_UPDATE',
            'message': 'BLE Module Upgrade Success',
            'error': false,
            'additional_info': {
              'address': address,
            }
          });
          print('🔷 BLE FIRMWARE UPGRADE COMPLETED SUCCESSFULLY');
          _setUpdateState('BLE firmware update completed!');
          unawaited(_onBLEUpdated());
        },
        onError: (address, error, errorType, message) {
          _logService.addFirmwareUpgradeLogReport(log: {
            'type': 'FIRMWARE_UPDATE',
            'message': 'BLE Module Upgrade Error',
            'error': true,
            'additional_info': {
              'error value': error,
              'address': address,
              'error type': errorType,
              'message': message
            }
          });
          print('❌ BLE FIRMWARE UPGRADE FAILED: $message');
          _setUpdateState('BLE firmware update failed: $message');
          unawaited(_onBLEUpdateFailed());
        },
      );
    } on Exception catch (e) {
      _logService.addFirmwareUpgradeLogReport(log: {
        'type': 'FIRMWARE_UPDATE',
        'message': 'BLE Module Upgrade Exception',
        'error': true,
        'additional_info': {
          'exception': e.toString(),
        }
      });
      print('❌ BLE FIRMWARE UPGRADE EXCEPTION: $e');
      _setUpdateState('BLE firmware update exception: $e');
      await _onBLEUpdateFailed();
    }
  }

  /// Start device scanning and upgrade process
  Future _startScanAndUpgrade() async {
    print('📡 ===============================================');
    print('📡 *** DEVICE SCANNING STARTED *** 📡');
    print('📡 Scanning for flask device to connect...');
    print('📡 ===============================================');

    _setUpdateState('Scanning for device...');

    await bleUtil.checkBleState(context, () async {
      print('🔍 Starting device scan for upgrade...');

      await bleUtil.startScan(listener: (r) async {
        BluetoothDevice device = r.device;

        // Check if this is our target device
        if (device.advName.isNotEmpty &&
            (device.advName.toLowerCase().contains('flask') ||
                device.advName.toLowerCase().contains('echo'))) {
          print('📱 ===============================================');
          print('📱 *** DEVICE FOUND & CONNECTED *** 📱');
          print('📱 Found target device: ${device.advName}');
          print(
              '📱 Starting ${_updateType.name.toUpperCase()} firmware transfer...');
          print('📱 ===============================================');

          await bleUtil.stopScan();

          print('~~~~~~~~~ _updateType line: 1554: $_updateType');

          // Start the appropriate upgrade based on update type
          if (_updateType == UpdateType.ble) {
            await _doFirmwareUpgradeWithDevice(device);
          } else if (_updateType == UpdateType.mcu) {
            await _updateMcuWithDevice(device);
          } else if (_updateType == UpdateType.images) {
            await _updatePicsWithDevice(device);
          }
        }
      });

      // If no device found after scan timeout
      _setUpdateState('Device not found. Retrying...');
      _cyclesCount--;
      if (_cyclesCount > 0) {
        await Future.delayed(Duration(seconds: 2));
        await _startScanAndUpgrade();
      } else {
        _setUpdateState('Device scan failed. Please try again.');
        if (_updateType == UpdateType.ble) {
          await _onBLEUpdateFailed();
        } else if (_updateType == UpdateType.mcu) {
          await _onMcuUpdateFailed();
        } else if (_updateType == UpdateType.images) {
          await _onImageLibraryUpdateFailed();
        }
      }
    });
  }

  Future updatePics() async {
    print('🟢 IMAGE LIBRARY UPGRADE STARTED');
    _setUpdateState('Starting image library upgrade...');

    // Reset progress for this specific update
    _currentItemProgress = 0.0;
    _isCurrentItemComplete = false;

    // Start device scanning and connection
    await _startScanAndUpgrade();
  }

  Future<void> onUpgradeButtonClick() async {
    if (_updateStatus == UpdateStatus.updating) {
      print('⚠️ UPGRADE ALREADY IN PROGRESS - IGNORING BUTTON CLICK');
      return;
    }

    print('🚀 ===============================================');
    print(
        '🚀 FIRMWARE UPGRADE STARTED FOR VERSION ${currentVersion == 0 ? "6.0" : currentVersion == 1 ? "7.0" : "8.0"}');
    print('🚀 ===============================================');
    print('📊 Upgrade Configuration:');
    print(
        '   • BLE Path: ${widget.blePath ?? "Not provided (using simulation)"}');
    print(
        '   • MCU Path: ${_processedUpgradeData![currentVersion]['mcuPath'] ?? "Not provided (using simulation)"}');
    print(
        '   • Image Paths: ${widget.imageLibraryPaths?.length ?? 0} images${widget.imageLibraryPaths?.isEmpty ?? true ? " (using simulation)" : ""}');
    print('   • Total Items to Update: $_totalItemsCount');
    print('🚀 ===============================================');

    // Reset progress for current version
    _initializeProgress();

    setState(() {
      progresses[currentVersion] = 0.0;
    });

    _logService.addFirmwareUpgradeLogReport(log: {
      'type': 'FIRMWARE_UPDATE',
      'error': false,
      'message': 'Upgrade button clicked',
      'additional_info': {
        'initial_start_set': {
          'ble_path': widget.blePath,
          'mcu_path': _processedUpgradeData![currentVersion]['mcuPath'],
          'images': "No Images",
        }
      }
    });

    if (_updateStatus == UpdateStatus.updating) {
      return;
    }
    //HOVO if need ble update change update type
    _updateType = UpdateType.mcu;

    _hasBaseDisconnected = true;
    await BleManager().disconnect(widget.flask!);
    BleManager().updateScanResultListener(isPause: true);

    // Don't call refreshFlaskVersion here as upgrade is just starting
    // Only log if we have valid version info
    if (widget.flask?.mcuVersion != null && widget.flask?.bleVersion != null) {
      try {
        _logService.sendFirmwareUpgradeLogReport(
            mcuVersion: widget.flask?.mcuVersion,
            bleVersion: widget.flask?.bleVersion);
      } catch (e) {
        print('⚠️ Error sending firmware upgrade log: $e');
      }
    }
    print(
        '~~~~~~~~~ refreshFlaskVersion.mcuVersion: ${widget.flask?.mcuVersion} ~~~~~~~~~~ ');
    print(
        '~~~~~~~~~ refreshFlaskVersion.bleVersion: ${widget.flask?.bleVersion} ~~~~~~~~~~ ');

    _initiateMCUUpdate();
  }

  void _initiateBLEUpgrade() {
    if (_hasUpdatedBLE) {
      _initiateMCUUpdate();
      return;
    }

    print('🔷 ===============================================');
    print('🔷 *** BLE UPDATE STARTED *** 🔷');
    print(
        '🔷 Initiating BLE Upgrade - Path: ${widget.blePath ?? "Not provided (using simulation)"}');
    print('🔷 ===============================================');

    // Show user notification for BLE update start
    _setUpdateState('Starting BLE firmware update...');

    // Always run BLE upgrade for testing, even if no path provided
    _updateType = UpdateType.ble;
    _cyclesCount = widget.cycleNumber ?? 5;
    _startScanTry();
  }

  Future<void> _onBLEUpdated() async {
    _hasUpdatedBLE = true;
    print('✅ BLE UPDATE COMPLETED - MOVING TO MCU UPDATE');
    await Future.delayed(
        Duration(milliseconds: 500)); // Brief pause between updates
    await _initiateMCUUpdate();
  }

  Future<void> _onBLEUpdateFailed() async {
    _cyclesCount = _cyclesCount - 1;
    if (_cyclesCount == 0) {
      _onFirmwareUpdateIssueLog(
          'This is firmware BLE update fail as cycle count is 0');
      await _onFullFirmwareUpdateCompleted(isSuccess: false);
    } else {
      await _startScan();
    }
  }

  Future<void> _initiateMCUUpdate() async {
    if (_hasUpdatedMCU) {
      _initiateImageUpdates();
      return;
    }

    if (_processedUpgradeData![currentVersion]['mcuPath'] == null) {
      _initiateImageUpdates();
      return;
    }

    print('🟠 ===============================================');
    print('🟠 *** MCU UPDATE STARTED *** 🟠');
    print(
        '🟠 Initiating MCU Upgrade - Path: ${_processedUpgradeData![currentVersion]['mcuPath'] ?? "Not provided (using simulation)"}');
    print('🟠 ===============================================');

    // Show user notification for MCU update start
    _setUpdateState('Starting MCU firmware update...');

    // Always run MCU upgrade for testing, even if no path provided
    _updateType = UpdateType.mcu;
    _cyclesCount = widget.cycleNumber ?? 5;
    _startScanTry();
  }

  Future<void> _onMCUUpdated() async {
    _hasUpdatedMCU = true;
    print('✅ MCU UPDATE COMPLETED - MOVING TO IMAGE UPDATES');

    await bleUtil.disconnect();
    await Future.delayed(const Duration(seconds: 2));
    _initiateImageUpdates();
  }

  Future<void> _onMcuUpdateFailed() async {
    await bleUtil.disconnect();
    if (_updateType == UpdateType.mcu) {
      _cyclesCount = _cyclesCount - 1;
      if (_cyclesCount > 0) {
        _startScanTry();
      } else {
        await _onFullFirmwareUpdateCompleted(isSuccess: false);
      }
    } else {
      _onFirmwareUpdateIssueLog(
          'This is MCU update fail but the update type is: $_updateType ');
      await _onFullFirmwareUpdateCompleted(isSuccess: false);
    }
  }

  void _initiateImageUpdates() {
    print('🟢 ===============================================');
    print('🟢 *** IMAGE UPDATES STARTED *** 🟢');
    print(
        '🟢 Initiating Image Updates - Images: ${imagePaths.length > 0 ? imagePaths.length : "0 (using simulation)"}');
    print('🟢 ===============================================');
    imagePaths = _processedUpgradeData![currentVersion]['imagePaths'];
    print('imagePaths: $imagePaths');
    if (imagePaths.isEmpty) {
      BleManager().updateFirmwareLog(widget.flask!, 'image');
      BleManager().updateFirmwareLog(widget.flask!, 'mcu');
      _onFullFirmwareUpdateCompleted(isSuccess: true);
      return;
    }

    // Show user notification for image update start
    _setUpdateState('Starting image library update...');

    // Always run image updates for testing, even if no images provided
    _updateType = UpdateType.images;
    _cyclesCount = widget.cycleNumber ?? 5;
    _startScanTry();
  }

  Future<void> _onImageUpdateCompleted() async {
    print('✅ IMAGE UPDATES COMPLETED - FIRMWARE UPGRADE FINISHED');

    BleManager().updateFirmwareLog(widget.flask!, 'image');
    BleManager().updateFirmwareLog(widget.flask!, 'mcu');
    _updateAllState();
    await bleUtil.disconnect();
    await Future.delayed(const Duration(seconds: 2));
    await _onFullFirmwareUpdateCompleted(isSuccess: true);
  }

  Future<void> _onImageLibraryUpdateFailed() async {
    await bleUtil.disconnect();
    if (_updateType == UpdateType.images) {
      _cyclesCount = _cyclesCount - 1;
      if (_cyclesCount > 0) {
        _startScanTry();
      } else {
        await _onFullFirmwareUpdateCompleted(isSuccess: false);
      }
    } else {
      _onFirmwareUpdateIssueLog('This is the image library update failure.');
      await _onFullFirmwareUpdateCompleted(isSuccess: false);
    }
  }

  Future<void> _onFullFirmwareUpdateCompleted({required bool isSuccess}) async {
    _logService.addFirmwareUpgradeLogReport(log: {
      'type': 'FIRMWARE_UPDATE',
      'message': 'Full Firmware Update completed',
      'error': !isSuccess,
      'additional_info': {
        'update status': _updateStatus.name,
      }
    });
    final message =
        isSuccess ? 'Firmware successfully updated.' : 'Firmware update failed';
    print(
        "~~~~~~~~~ FIRMWARE UPDATE COMPLETED ~~~~~~~~~ isSuccess: $isSuccess");
    showToast(context, message,
        style: isSuccess ? SnackbarStyle.success : SnackbarStyle.error);
    _setUpdateState(message);
    _updateStatus =
        isSuccess ? UpdateStatus.updateSuccess : UpdateStatus.updateFailed;
    _updateAllState();
    await bleUtil.disconnect();
    _disposeBLEUtil();
    if (_hasBaseDisconnected) {
      BleManager().updateScanResultListener(isPause: false);
      _hasBaseDisconnected = false;
      await BleManager().connectFlask(device: widget.flask!, connectTime: 5);
    }
  }

  void _disposeBLEUtil() {
    // Properly dispose BLE utility
    bleUtil.dispose();
  }

  /// Show error dialog when BLE model is missing and navigate back
  void _showBleModelErrorDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: const Color(0xFF2E2E2E), // dark background
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Text(
                  'Update error',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),

                // Body text
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Colors.white.withOpacity(0.7),
                    ),
                    children: [
                      const TextSpan(
                          text:
                              "Please retry the firmware update. If that doesn't resolve the issue, please check our "),
                      TextSpan(
                        text: "help article",
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blueAccent,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Open help article
                          },
                      ),
                      const TextSpan(text: " or "),
                      TextSpan(
                        text: "contact support",
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blueAccent,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Open contact support
                          },
                      ),
                      const TextSpan(text: "."),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Close Button
                    TextButton(
                      onPressed: () {
                        // Close dialog first
                        Navigator.of(context).pop();
                        // Then go back to personalization screen
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "Close Update",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Retry Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      onPressed: () {
                        // Retry logic
                        Navigator.of(context).pop();
                        print('Retry button pressed');
                        onUpgradeButtonClick();
                      },
                      child: const Text(
                        "Retry",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  /// Set up MCU version listener for real-time updates
  void _setupMcuVersionListener() {
    BleManager().onFlaskMCURead = (device, mcuVersion) {
      if (device.identifier == widget.flask?.serialId ||
          device.identifier == widget.flask?.appBleModelDevice?.identifier) {
        setState(() {
          _realTimeMcuVersion = mcuVersion;
          _isLoadingMcuVersion = false;
          _mcuVersionError = null; // Clear any previous errors on success
        });
        print('📊 Real-time MCU Version received: $mcuVersion');
      }
    };
  }

  /// Get current MCU version from multiple sources
  String getCurrentMcuVersion() {
    // Priority order: Real-time BLE > Widget Flask > API Version Data
    if (_realTimeMcuVersion != null) {
      print('🔄 Real-time MCU Version received: $_realTimeMcuVersion');
      return _realTimeMcuVersion!.toString();
    }

    // if (widget.flask?.mcuVersion != null &&
    //     widget.flask!.mcuVersion!.isNotEmpty) {
    //   print(
    //       '🔄 Widget Flask MCU Version received: ${widget.flask!.mcuVersion}');
    //   return widget.flask!.mcuVersion!;
    // }

    // if (_flaskVersionData?.currentVerion != null) {
    //   print(
    //       '🔄 API Version Data received: ${_flaskVersionData!.currentVerion}');
    //   return _flaskVersionData!.currentVerion!;
    // }

    return 'Unknown';
  }

  /// Request fresh MCU version via BLE
  Future<void> _requestMcuVersionViaBLE() async {
    if (widget.flask?.appBleModelDevice == null) {
      print('⚠️ No BLE device available to request MCU version');
      setState(() {
        _mcuVersionError = 'No BLE device available. Please wait...';
        _isLoadingMcuVersion = false;
      });
      return;
    }

    setState(() {
      _isLoadingMcuVersion = true;
      _mcuVersionError = null; // Clear previous errors
    });

    print('📡 Requesting MCU version via BLE...');

    try {
      // Send a wake up command to trigger device to send its status including MCU version
      final response = await BleManager().sendData(
        widget.flask!,
        FlaskCommand.wakeUp,
        FlaskCommand.wakeUp.commandData.addingCRC(),
      );

      if (response.isNotEmpty) {
        print('❌ Failed to request MCU version: $response');
        setState(() {
          _mcuVersionError = 'Failed to request: $response';
          _isLoadingMcuVersion = false;
        });
      } else {
        // Success response will come through the onFlaskMCURead callback
        // Set a timeout in case no response comes
        Future.delayed(const Duration(seconds: 5), () {
          if (_isLoadingMcuVersion) {
            setState(() {
              _mcuVersionError = 'Request timeout - no response received';
              _isLoadingMcuVersion = false;
            });
          }
        });
      }
    } catch (e) {
      print('❌ Error requesting MCU version: $e');
      setState(() {
        _mcuVersionError = 'Error: ${e.toString()}';
        _isLoadingMcuVersion = false;
      });
    }
  }

  void showUpdateErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: const Color(0xFF2E2E2E), // dark background
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Text(
                  'Update error',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),

                // Body text
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Colors.white.withOpacity(0.7),
                    ),
                    children: [
                      const TextSpan(
                          text:
                              "Please retry the firmware update. If that doesn't resolve the issue, please check our "),
                      TextSpan(
                        text: "help article",
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blueAccent,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Open help article
                          },
                      ),
                      const TextSpan(text: " or "),
                      TextSpan(
                        text: "contact support",
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blueAccent,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Open contact support
                          },
                      ),
                      const TextSpan(text: "."),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Close Button
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "Close Update",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Retry Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      onPressed: () {
                        print("~~~~~~~~~ RETRY BUTTON PRESSED ~~~~~~~~~");
                        // Retry logic
                        Navigator.of(context).pop();
                        print('Retry button pressed');
                        onUpgradeButtonClick();
                      },
                      child: const Text(
                        "Retry",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
