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
  UpdateType _updateType = UpdateType.ble;
  int _cyclesCount = 0;
  bool _onScanSuccess = false;
  int _scanTryCount = 0;
  static const int blockSize = 128;
  bool _hasBaseDisconnected = false;
  bool _hasUpdatedBLE = false;
  bool _hasUpdatedMCU = false;
  List<String> imagePaths = [];
  List<String> successImages = [];

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

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    _cyclesCount = widget.cycleNumber ?? 5;
    imagePaths = widget.imageLibraryPaths ?? [];

    // Print all upgrade data in a readable format
    print("=== ALL UPGRADE DATA ===");
    if (widget.allUpgradeData != null) {
      print("Total responses: ${widget.allUpgradeData!.length}");
      for (int i = 0; i < widget.allUpgradeData!.length; i++) {
        final data = widget.allUpgradeData![i];
        print("Response $i:");
        print("  blePath: ${data['blePath']}");
        print("  mcuPath: ${data['mcuPath']}");
        print("  imagePaths: ${data['imagePaths']}");
        print("  hasUpgrades: ${data['hasUpgrades']}");
        print("  responseIndex: ${data['responseIndex']}");
        print("  totalResponses: ${data['totalResponses']}");
        print("---");
      }
    } else {
      print("allUpgradeData is null");
    }
    print(
        "========================= END OF ALL UPGRADE DATA ========================= ");
    print("widget.allUpgradeData!.length : ${widget.allUpgradeData!.length}");
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
      curve: Curves.easeOutBack,
    ));

    // Setup button fade animation
    _buttonFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _buttonMoveAnimationController,
      curve: Curves.easeIn,
    ));

    _initializeProgress();

    // Fetch flask version data when screen opens
    _fetchFlaskVersionData();

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
      print('~~  Flask: ${upgradeData['flask']}');
      print('~  BLE Path: ${upgradeData['blePath']}');
      print('~  MCU Path: ${upgradeData['mcuPath']}');
      print('~  Image Paths: ${upgradeData['imagePaths']}');
      print('~  Target Version: ${upgradeData['targetVersion']}');
      print('~  Current BLE Version: ${upgradeData['currentBleVersion']}');
      print('~  Current MCU Version: ${upgradeData['currentMcuVersion']}');
      print('~  Has Upgrades: ${upgradeData['hasUpgrades']}');
      print('~  Cycle Number: ${upgradeData['cycleNumber']}');
      print('~  Response Index: ${upgradeData['responseIndex']}');
      print('~  Total Responses: ${upgradeData['totalResponses']}');
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
      upgradeCount = widget.allUpgradeData!.length;
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
    _totalItemsCount += 1; // Always include BLE update for simulation
    _totalItemsCount += 1; // Always include MCU update for simulation
    _totalItemsCount += imagePaths.length > 0
        ? imagePaths.length
        : 1; // At least 1 image for simulation

    print('📊 Progress Initialization: Total Items = $_totalItemsCount');
  }

  void _calculateProgressAndShow({required int percentage}) {
    // Convert the percentage to a decimal value between 0.0 and 1.0
    _currentItemProgress = percentage / 100.0;

    // Ensure we always have at least 1 item to prevent division by zero
    if (_totalItemsCount == 0) {
      _totalItemsCount = 3; // Default to 3 items (BLE + MCU + 1 Image)
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
      _buttonMoveAnimationController.reverse().then((_) {
        setState(() {
          _progressTimer?.cancel();
          currentVersion++;
          progresses[currentVersion] = 0.01; // Start next version
        });
        _startProgressTimer(); // Restart timer for next version with new button position
      });
    }
  }

  void _handleNextUpdateOrResume() {
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
                    ? _handleNextUpdateOrResume
                    : null,
                child: Text(
                  isUpgradeInProgress ? "Upgrading..." : "Next Update",
                  style: TextStyle(
                    fontFamily: StringConstants.golosFont,
                    fontSize: 14,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w600,
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

  /// Get version label for progress bar
  String _getVersionLabel(int index) {
    if (widget.allUpgradeData != null &&
        widget.allUpgradeData!.isNotEmpty &&
        index < widget.allUpgradeData!.length) {
      final upgradeData = widget.allUpgradeData![index];

      // Create descriptive label based on what upgrades are available
      List<String> upgradeTypes = [];
      if (upgradeData['blePath'] != null) upgradeTypes.add('BLE');
      if (upgradeData['mcuPath'] != null) upgradeTypes.add('MCU');
      if (upgradeData['imagePaths'] != null &&
          upgradeData['imagePaths'].isNotEmpty) upgradeTypes.add('Images');

      // Use target version if available, otherwise use index + 1
      String versionText = upgradeData['targetVersion'] ?? "${index + 1}";
      if (upgradeData['currentMcuVersion'] != null) {
        versionText = upgradeData['currentMcuVersion'];
      } else if (upgradeData['currentBleVersion'] != null) {
        versionText = upgradeData['currentBleVersion'];
      }

      if (upgradeTypes.isNotEmpty) {
        return "$versionText (${upgradeTypes.join(', ')})";
      } else {
        return versionText;
      }
    }

    // Fallback to default version names
    switch (index) {
      case 0:
        return "6.0";
      case 1:
        return "7.0";
      case 2:
        return "8.0";
      default:
        return "Version ${index + 1}";
    }
  }

  /// Check if all progress is complete
  bool _isAllProgressComplete() {
    if (progresses.isEmpty) return false;
    return currentVersion >= progresses.length - 1 && progresses.last >= 1.0;
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
          const SizedBox(height: 4),
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
            borderRadius: BorderRadius.circular(10),
          ),
          const SizedBox(height: 4),
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
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Firmware Update',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: StringConstants.golosFont,
                  fontSize: 32,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.48,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.flask?.name ?? 'Flask',
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: StringConstants.golosFont,
                  fontSize: 12,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w400,
                  height: 1.3, // 130% = 20.8 / 16 = 1.3
                  letterSpacing: 0.36,
                ),
              ),
              const SizedBox(height: 32),

              // Show dynamic progress bars based on allUpgradeData size
              if (widget.allUpgradeData != null &&
                  widget.allUpgradeData!.isNotEmpty) ...[
                ..._buildDynamicProgressBars(),
                const SizedBox(height: 32),
                Center(
                  child: Text(
                    _isAllProgressComplete()
                        ? "FIRMWARE UPDATE: COMPLETE"
                        : "FIRMWARE UPDATE: IN PROGRESS",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
              ],
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
                    ),
                    const SizedBox(height: 2),
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
                        fontWeight: FontWeight.w400,
                        height: 1.3, // 130% = 20.8 / 16 = 1.3
                        letterSpacing: 0.48,
                      ),
                    ),
                  ],
                ),
              ),

              // Add Spacer to push Finish button to bottom
              if (_isAllProgressComplete()) ...[
                const Spacer(),
                // Add Real OTA Upgrade button before Finish button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle finish action here
                      widget.refreshFlaskVersion?.call(true);
                      Navigator.of(context).pop(); // Go back to previous screen
                    },
                    child: Text(
                      "Finish",
                      style: TextStyle(
                        fontFamily: StringConstants.golosFont,
                        fontSize: 14,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.28,
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
                const SizedBox(height: 8), // 24px distance from bottom
              ]
            ],
          ),
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
    final updateTypeIcon = _updateType == UpdateType.ble
        ? '🔷'
        : _updateType == UpdateType.mcu
            ? '🟠'
            : '🟢';
    final updateTypeName = _updateType.name.toUpperCase();

    print("$updateTypeIcon STARTING DEVICE SCAN FOR $updateTypeName UPDATE");
    _setUpdateState('Scanning for device to update $updateTypeName...');

    Timer.periodic(Duration(milliseconds: 300), (timer) {
      final tick = timer.tick;
      print(
          '$updateTypeIcon Device Scan - Tick: $tick, Scanning for $updateTypeName update...');

      // Update state text based on scan progress
      if (tick <= 2) {
        _setUpdateState('Initializing Bluetooth scanner...');
      } else if (tick <= 4) {
        _setUpdateState('Scanning for flask device...');
      } else if (tick <= 6) {
        _setUpdateState('Device found! Connecting...');
      } else {
        _setUpdateState('Device connected. Starting $updateTypeName update...');
      }

      // Complete scan after 8 ticks (2.4 seconds)
      if (tick >= 8) {
        timer.cancel();
        print(
            "$updateTypeIcon DEVICE SCAN COMPLETED - STARTING $updateTypeName UPDATE");

        // Start the appropriate update
        if (_updateType == UpdateType.ble) {
          unawaited(_doFirmwareUpgrade());
        } else if (_updateType == UpdateType.mcu) {
          unawaited(_updateMcu());
        } else if (_updateType == UpdateType.images) {
          unawaited(updatePics());
        }
      }
    });

    return;
  }

  Future _updateMcu() async {
    print('🟠 MCU FIRMWARE UPGRADE STARTED');
    _setUpdateState('Starting MCU firmware upgrade...');

    // Reset progress for this specific update
    _currentItemProgress = 0.0;
    _isCurrentItemComplete = false;

    // Start device scanning and connection
    await _startScanAndUpgrade();
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
    if (widget.allUpgradeData != null &&
        widget.allUpgradeData!.isNotEmpty &&
        currentVersion < widget.allUpgradeData!.length) {
      mcuUpgradePath = widget.allUpgradeData![currentVersion]['mcuPath'];
    } else {
      mcuUpgradePath = widget.mcuPath;
    }

    if (mcuUpgradePath == null) {
      print('❌ No MCU upgrade path available');
      await _onMcuUpdateFailed();
      return;
    }

    await bleUtil.connect(context, device, (suc) async {
      if (suc) {
        final file = File(mcuUpgradePath!);
        final upgradeFile = await file.readAsBytes();

        final startMcu = await bleUtil.writeWait(
            Uint8List.fromList(
                [0x55, 0xAA, 0x33, 0xCC, 0x11, 0x1E, 0x1F, 0xF1]),
            12);

        Util.v('startMcu:${Util.getHexString(startMcu)}');
        await Future.delayed(const Duration(seconds: 1));
        final blockCount = (upgradeFile.length.toDouble() / blockSize).ceil();

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
          final successData = bleUtil.getBlockCmd(
              Uint8List.fromList([0x01]),
              true,
              Uint8List.fromList([0x00, 0x00, 0x00, 0x01]),
              blockCount,
              i + 1);
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

    // Use allUpgradeData for current upgrade
    List<String> imageUpgradePaths = [];
    if (widget.allUpgradeData != null &&
        widget.allUpgradeData!.isNotEmpty &&
        currentVersion < widget.allUpgradeData!.length) {
      final upgradeData = widget.allUpgradeData![currentVersion];
      imageUpgradePaths = List<String>.from(upgradeData['imagePaths'] ?? []);
    } else {
      imageUpgradePaths = imagePaths;
    }

    if (imageUpgradePaths.isEmpty) {
      print('❌ No image upgrade paths available');
      await _onImageLibraryUpdateFailed();
      return;
    }

    await bleUtil.connect(context, device, (suc) async {
      if (suc) {
        var imgSuccessCount = 0;
        successImages = [];

        _logService.addFirmwareUpgradeLogReport(log: {
          'type': 'FIRMWARE_UPDATE',
          'message': 'Image update started and device was found',
          'error': false
        });

        for (var k = 0; k < imageUpgradePaths.length; k++) {
          final file = File(imageUpgradePaths[k]);
          final upgradeFile = await file.readAsBytes();
          final startPics = await bleUtil.writeWait(
              Uint8List.fromList(
                  [0x55, 0xAA, 0x46, 0x4D, 0x44, 0x49, 0x41, 0x50]),
              3);
          Util.v('startPics:${Util.getHexString(startPics)}');
          final blockCount = (upgradeFile.length.toDouble() / blockSize).ceil();

          for (var i = 0; i < blockCount; i++) {
            _logService.addFirmwareUpgradeLogReport(log: {
              'type': 'FIRMWARE_UPDATE',
              'message': 'Image Upgrade in progress',
              'error': false,
              'additional_info': {
                'image number': k,
                'block count': blockCount,
                'current block': i
              }
            });

            final block = upgradeFile.sublist(
                i * blockSize, min((i + 1) * blockSize, upgradeFile.length));
            final data = await bleUtil.sendBlock(
                bleUtil.getBlockCmd(
                    block,
                    false,
                    Util.hex4ToUint8List(
                        path.basenameWithoutExtension(imageUpgradePaths[k])),
                    blockCount,
                    i + 1),
                1);
            final percent =
                (((i + 1).toDouble() / blockCount.toDouble()) * 100).toInt();

            final successData = bleUtil.getBlockCmd(
                Uint8List.fromList([0x01]),
                false,
                Util.hex4ToUint8List(
                    path.basenameWithoutExtension(imageUpgradePaths[k])),
                blockCount,
                i + 1);
            if (Util.areUint8ListsEqual(data, successData)) {
              _setUpdateState(
                  'Image ${k + 1}/${imageUpgradePaths.length}: $percent%');
              _calculateProgressAndShow(percentage: percent);
              if (i + 1 == blockCount) {
                imgSuccessCount = imgSuccessCount + 1;
                successImages.add(imageUpgradePaths[k]);
              }
            } else {
              break;
            }
          }
        }

        if (imgSuccessCount == imageUpgradePaths.length) {
          _logService.addFirmwareUpgradeLogReport(log: {
            'type': 'FIRMWARE_UPDATE',
            'message': 'All Image upgrade success',
            'error': false,
            'additional_info': {
              'success images': successImages,
            }
          });
          _setUpdateState('Image library update completed!');
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
          imageUpgradePaths.removeWhere((item) => successImages.contains(item));
          unawaited(_onImageLibraryUpdateFailed());
        }
      } else {
        _logService.addFirmwareUpgradeLogReport(log: {
          'type': 'FIRMWARE_UPDATE',
          'message': 'Image update failed',
          'error': true,
          'additional_info': {
            'message': 'Connecting to device not successful',
            'device advertising address': device.advName,
          }
        });
        unawaited(_onImageLibraryUpdateFailed());
      }
    });
  }

  Future _doFirmwareUpgrade() async {
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
        '   • MCU Path: ${widget.mcuPath ?? "Not provided (using simulation)"}');
    print(
        '   • Image Paths: ${widget.imageLibraryPaths?.length ?? 0} images${widget.imageLibraryPaths?.isEmpty ?? true ? " (using simulation)" : ""}');
    print('   • Total Items to Update: $_totalItemsCount');
    print('🚀 ===============================================');

    _updateStatus = UpdateStatus.updating;
    isUpdating = true;

    // Reset progress for current version
    _initializeProgress();

    setState(() {
      progresses[currentVersion] = 0.0;
    });

    _initiateBLEUpgrade();
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

    print('🟠 ===============================================');
    print('🟠 *** MCU UPDATE STARTED *** 🟠');
    print(
        '🟠 Initiating MCU Upgrade - Path: ${widget.mcuPath ?? "Not provided (using simulation)"}');
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
    await Future.delayed(
        Duration(milliseconds: 500)); // Brief pause between updates
    _initiateImageUpdates();
  }

  Future<void> _onMcuUpdateFailed() async {
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

    // Show user notification for image update start
    _setUpdateState('Starting image library update...');

    // Always run image updates for testing, even if no images provided
    _updateType = UpdateType.images;
    _cyclesCount = widget.cycleNumber ?? 5;
    _startScanTry();
  }

  Future<void> _onImageUpdateCompleted() async {
    print('✅ IMAGE UPDATES COMPLETED - FIRMWARE UPGRADE FINISHED');
    _updateAllState();
    await Future.delayed(
        Duration(milliseconds: 500)); // Brief pause before completion
    await _onFullFirmwareUpdateCompleted(isSuccess: true);
  }

  Future<void> _onImageLibraryUpdateFailed() async {
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
    final versionName = currentVersion == 0
        ? "6.0"
        : currentVersion == 1
            ? "7.0"
            : "8.0";
    final statusIcon = isSuccess ? '🎉' : '❌';
    final statusText = isSuccess ? 'SUCCESS' : 'FAILED';

    print('$statusIcon ===============================================');
    print('$statusIcon FIRMWARE UPGRADE $statusText FOR VERSION $versionName');
    print('$statusIcon ===============================================');
    print('📊 Upgrade Summary:');
    print(
        '   • BLE Update: ${_hasUpdatedBLE ? "✅ Completed" : "❌ Not completed"}');
    print(
        '   • MCU Update: ${_hasUpdatedMCU ? "✅ Completed" : "❌ Not completed"}');
    print(
        '   • Image Updates: ${isSuccess ? "✅ Completed" : "❌ Not completed"}');
    print(
        '   • Overall Progress: ${(_overallProgress * 100).toStringAsFixed(1)}%');
    print('$statusIcon ===============================================');

    final message =
        isSuccess ? 'Firmware successfully updated.' : 'Firmware update failed';

    if (mounted) {
      Utilities.showSnackBar(context, message,
          isSuccess ? SnackbarStyle.success : SnackbarStyle.error);
    }

    _setUpdateState(message);
    _updateStatus =
        isSuccess ? UpdateStatus.updateSuccess : UpdateStatus.updateFailed;

    // Mark current version as complete
    setState(() {
      progresses[currentVersion] = 1.0;
      isUpdating = false;
    });

    // Reset for next version if successful and not the last version
    if (isSuccess && currentVersion < progresses.length - 1) {
      print('🔄 PREPARING FOR NEXT VERSION UPDATE...');
      // Reset update state for next version
      _hasUpdatedBLE = false;
      _hasUpdatedMCU = false;
      _updateStatus = UpdateStatus.idle;
      _initializeProgress();
    } else if (isSuccess && currentVersion >= progresses.length - 1) {
      print('🏁 ALL FIRMWARE UPDATES COMPLETED SUCCESSFULLY!');
    }

    _updateAllState();
    _disposeBLEUtil();
  }

  void _disposeBLEUtil() {
    // Properly dispose BLE utility
    try {
      bleUtil.dispose();
      print('🔌 BLE utility disposed successfully');
    } catch (e) {
      print('⚠️ Error disposing BLE utility: $e');
    }
  }

  // Add unawaited helper if not imported
  void unawaited(Future<void> future) {
    // Intentionally not awaiting
  }
}
