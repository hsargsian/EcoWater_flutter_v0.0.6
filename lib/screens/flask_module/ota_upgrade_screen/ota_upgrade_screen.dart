import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:echowater/base/common_widgets/buttons/app_button.dart';
import 'package:echowater/base/common_widgets/snackbar/snackbar_style.dart';
import 'package:echowater/base/utils/colors.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/base/utils/utilities.dart';
import 'package:echowater/core/domain/domain_models/flask_domain.dart';
import 'package:echowater/core/injector/injector.dart';
import 'package:echowater/flavor_config.dart';
import 'package:echowater/oc_libraries/ble_service/ble_manager.dart';
import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:nordic_dfu/nordic_dfu.dart';
import 'package:path/path.dart' as path;
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../base/common_widgets/buttons/normal_button_text.dart';
import '../../../base/common_widgets/image_widgets/app_image_view.dart';
import '../../../base/common_widgets/navbar/echo_water_nav_bar.dart';
import '../../../base/common_widgets/navbar/nav_bar.dart';
import '../../../base/utils/images.dart';
import '../../../core/services/firmware_update_log_report_service.dart';
import 'ble_utils.dart';
import 'util.dart';

enum OTAUpdateType {
  bleModule,
  mcu,
  pictue;
}

class OtaUpgradeScreen extends StatefulWidget {
  const OtaUpgradeScreen(
      {required this.flask,
      required this.cycleNumber,
      required this.blePath,
      required this.mcuPath,
      required this.imgPath,
      this.refreshFlaskVersion,
      super.key});
  final FlaskDomain flask;
  final int cycleNumber;
  final String? mcuPath;
  final String? blePath;
  final List<String>? imgPath;
  final void Function(bool)? refreshFlaskVersion;

  @override
  State<OtaUpgradeScreen> createState() => _OtaUpgradeScreenState();

  static Route<void> route(
      {required FlaskDomain flask,
      required int cycleNumber,
      required String? blePath,
      String? mcuPath,
      List<String>? imageLibraryPath,
      Function(bool)? refreshFlaskVersion}) {
    return MaterialPageRoute<void>(
        settings: const RouteSettings(name: '/OtaUpgradeScreen'),
        builder: (_) => OtaUpgradeScreen(
              flask: flask,
              cycleNumber: cycleNumber,
              blePath: blePath,
              mcuPath: mcuPath,
              imgPath: imageLibraryPath,
              refreshFlaskVersion: refreshFlaskVersion,
            ));
  }
}

enum UpdateType {
  ble,
  mcu,
  images;
}

enum UpdateStatus { idle, updating, updateSuccess, updateFailed }

class _OtaUpgradeScreenState extends State<OtaUpgradeScreen> {
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
  late final FirmwareUpdateLogReportService _logService;

  double _currentItemProgress = 0;
  int _completedItemsCount = 0;
  double _overallProgress = 0;
  int _totalItemsCount = 0;
  bool _isCurrentItemComplete = false;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    _cyclesCount = widget.cycleNumber;
    imagePaths = widget.imgPath ?? [];
    _logService = Injector.instance<FirmwareUpdateLogReportService>()
      ..startFirmwareUpgradeLogReport(flask: widget.flask)
      ..addFirmwareUpgradeLogReport(log: {
        'type': 'FIRMWARE_UPDATE',
        'message': 'Opened the screen for firmware update',
        'error': false
      });
    _initializeProgress();
  }

  void _initializeProgress() {
    _currentItemProgress = 0.0;
    _completedItemsCount = 0;
    _overallProgress = 0.0;
    _isCurrentItemComplete = false;

    // Count total items at initialization
    _totalItemsCount = 0;
    _totalItemsCount += widget.blePath == null ? 0 : 1;
    _totalItemsCount += widget.mcuPath == null ? 0 : 1;
    _totalItemsCount += widget.imgPath == null ? 0 : widget.imgPath!.length;
  }

  void _setUpdateState(String tips) {
    _updateStateText = tips;
    _updateAllState();
  }

  void _calculateProgressAndShow({required int percentage}) {
    // Convert the percentage to a decimal value between 0.0 and 1.0
    _currentItemProgress = percentage / 100.0;

    // If there's nothing to update, just return
    if (_totalItemsCount == 0) {
      return;
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

    // Display percentage with careful rounding
    final displayPercentage = (_overallProgress * 100).toStringAsFixed(1);

    // Update UI with the overall progress
    setState(() {
      // Update your progress bar with _overallProgress
    });

    if (kDebugMode) {
      print(
          'Ashwin Percentage log: ${_updateType.name} and percentage: $percentage, ' +
              'Overall: $displayPercentage%, ' +
              'Completed: $_completedItemsCount/$_totalItemsCount');
    }

    // If all items are complete, ensure we show 100%
    if (_completedItemsCount == _totalItemsCount) {
      _overallProgress = 1.0;
      setState(() {
        // Update progress bar to show complete
      });
      if (kDebugMode) {
        print('Ashwin Percentage log: All items complete, Overall: 100%');
      }
    }

    // If this item is complete and we're moving to the next one, reset the current progress
    if (_isCurrentItemComplete && _updateType.name != 'COMPLETE') {
      _isCurrentItemComplete = false;
      _currentItemProgress = 0.0;
    }
  }

  Future _updateMcu(BluetoothDevice device) async {
    _logService.addFirmwareUpgradeLogReport(log: {
      'type': 'FIRMWARE_UPDATE',
      'message':
          'MCU Module Upgrade Started. Will start searching and connecting',
      'error': false,
      'additional_info': {
        'device advertising address': device.advName,
      }
    });

    await bleUtil.connect(context, device, (suc) async {
      if (suc) {
        final file = File(widget.mcuPath!);
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
              unawaited(_onMCUUpdated());
              return;
            }

            _logService.addFirmwareUpgradeLogReport(log: {
              'type': 'FIRMWARE_UPDATE',
              'message': 'MCU Module Upgrade In Progress',
              'error': false,
              'additional_info': {'Percentage': '$percent%', 'Block Index': i}
            });
            _calculateProgressAndShow(percentage: percent);
          } else {
            _logService.addFirmwareUpgradeLogReport(log: {
              'type': 'FIRMWARE_UPDATE',
              'message': 'MCU Module Upgrade Failed.',
              'error': true,
              'additional_info': {'Percentage': '$percent%', 'Block Index': i}
            });
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
      }
      await _onMcuUpdateFailed();
    });
  }

  void _onFirmwareUpdateIssueLog(String log) {
    if (log.isNotEmpty) {
      BleManager().onNewLog?.call([], 'Firmware Update', true, log, false);
    }
    _setUpdateState(
        'There seems to be some problem updating the firmware. Please try again.');
  }

  void _updateAllState() {
    if (mounted) {
      setState(() {});
    }
  }

  void _startScanTry() {
    _scanTryCount = 5;
    _startScan();
  }

  Future<void> _startScan() async {
    final serialId = widget.flask.appBleModelDevice?.bleDevice.remoteId.str ??
        widget.flask.serialId;
    if (widget.flask.appBleModelDevice == null) {
      _logService.addFirmwareUpgradeLogReport(log: {
        'type': 'FIRMWARE_UPDATE',
        'message': 'Firmware Update Failed',
        'error': true,
        'additional_info': {
          'message':
              'Somehow the Flask doesnt have the app ble model will be using flask serial id',
        }
      });
    }
    await bleUtil.checkBleState(context, () async {
      _updateStatus = UpdateStatus.updating;
      _onScanSuccess = false;
      _setUpdateState('Firmware upgrade in progress. Please wait...');
      await bleUtil.startScan(listener: (r) async {
        var isFilter = false;
        final mac = serialId.replaceAll(':', '').toUpperCase();
        if (mac.isNotEmpty) {
          final rMac = r.device.remoteId.str.replaceAll(':', '').toUpperCase();
          if (rMac.contains(mac)) {
            isFilter = true;
          }
        }
        if (isFilter) {
          _onScanSuccess = true;
          await bleUtil.stopScan();
          if (_updateType == UpdateType.ble) {
            await _doFirmwareUpgrade(r.device);
          } else if (_updateType == UpdateType.mcu) {
            await _updateMcu(r.device);
          } else if (_updateType == UpdateType.images) {
            await updatePics(r.device);
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

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: EchoWaterNavBar(
            child: NavBar(
          navStyle: NavStyle.singleLined,
          navTitle: 'Firmware Update',
          textColor: Theme.of(context).colorScheme.primaryElementColor,
          sideMenuItems: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: NormalTextButton(
                title: 'Cancel'.localized,
                onClick: () {
                  _onExitScreen();
                },
              ),
            )
          ],
        )),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 30,
                ),
                const AppImageView(
                  placeholderImage: Images.sampleWaterBottlePngImage,
                  placeholderWidth: 120,
                  height: 300,
                  cornerRadius: 0,
                  placeholderHeight: 300,
                  placeholderFit: BoxFit.contain,
                ),
                if (_updateStatus == UpdateStatus.updating)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      children: [
                        LinearProgressIndicator(
                            value: _overallProgress,
                            minHeight: 10,
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .primaryElementColor,
                            borderRadius: BorderRadius.circular(10)),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                            '${(_overallProgress * 100).toStringAsFixed(1)}% Completed'),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                _upgradeButton(),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    _updateStateText,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
                const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Text(
                      'IMPORTANT: Please keep the app open and your phone unlocked during the update process. Interrupting this process may cause device malfunction.',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    )),
                if (FlavorConfig.isNotProduction())
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.tertiary,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Information about what is getting updated',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondaryElementColor),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(widget.blePath == null
                                ? 'No BLE to upgrade'
                                : 'BLE: ${path.basename(widget.blePath!)}'),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(widget.mcuPath == null
                                ? 'No MCU to upgrade'
                                : 'MCU: ${path.basename(widget.mcuPath!)}'),
                            const SizedBox(
                              height: 5,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Images:'),
                                const SizedBox(
                                  height: 2,
                                ),
                                Text(widget.imgPath == null
                                    ? 'No images to upgrade'
                                    : (widget.imgPath ?? [])
                                        .map(path.basename)
                                        .join('\n')),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _disposeBLEUtil();
    super.dispose();
  }

  void _onExitScreen() {
    _disposeBLEUtil();
    if (_updateStatus == UpdateStatus.updating) {
      Utilities.showSnackBar(
          context, 'Update in progress. Please wait.', SnackbarStyle.error);
    } else {
      _logService.addFirmwareUpgradeLogReport(log: {
        'type': 'FIRMWARE_UPDATE',
        'message': 'Exiting firmware Screen',
        'error': _updateStatus == UpdateStatus.updateFailed,
        'additional_info': {'current update status': _updateStatus.name}
      });
      if (_hasBaseDisconnected) {
        BleManager().updateScanResultListener(isPause: false);
        BleManager().connectFlask(device: widget.flask, connectTime: 5);
      }
      widget.refreshFlaskVersion?.call(true);
      _logService.sendFirmwareUpgradeLogReport(
          mcuVersion: widget.flask.mcuVersion,
          bleVersion: widget.flask.bleVersion);
      WakelockPlus.disable();
      Navigator.pop(context);
    }
  }

  Widget _upgradeButton() {
    final isUpgradeInProgress = _updateStatus == UpdateStatus.updating;
    final isUpdateSuccess = _updateStatus == UpdateStatus.updateSuccess;
    if (isUpdateSuccess) {
      return AppButton(
          title: 'View Flask Details',
          textColor: Theme.of(context).colorScheme.primaryElementColor,
          backgroundColor: AppColors.green,
          onClick: () {
            _onExitScreen();
          });
    }
    return Opacity(
      opacity: isUpgradeInProgress ? 0.5 : 1.0,
      child: AppButton(
          title:
              isUpgradeInProgress ? 'Upgrade in Progress' : 'Upgrade Firmware',
          textColor: Theme.of(context).colorScheme.primaryElementColor,
          onClick: () {
            _onUpgradeButtonClick();
          }),
    );
  }

  Future updatePics(BluetoothDevice device) async {
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
          final file = File(imagePaths[k]);
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
    _logService.addFirmwareUpgradeLogReport(log: {
      'type': 'FIRMWARE_UPDATE',
      'message': 'BLE Module Upgrade Started',
      'error': false,
      'additional_info': {
        'device advertising address': device.advName,
      }
    });
    try {
      await NordicDfu().startDfu(
        device.remoteId.str,
        widget.blePath!,
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
          _onBLEUpdated();
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

          _onBLEUpdateFailed();
        },
      );
    } on Exception catch (e) {
      _logService.addFirmwareUpgradeLogReport(log: {
        'type': 'FIRMWARE_UPDATE',
        'message': 'BLE Module Upgrade Error',
        'error': true,
        'additional_info': {
          'error value': e.toString(),
          'message': 'There was sone error  from try catch block'
        }
      });
    }
  }

  Future<void> _onUpgradeButtonClick() async {
    _logService.addFirmwareUpgradeLogReport(log: {
      'type': 'FIRMWARE_UPDATE',
      'error': false,
      'message': 'Upgrade button clicked',
      'additional_info': {
        'initial_start_set': {
          'ble_path': widget.blePath,
          'mcu_path': widget.mcuPath,
          'images': widget.imgPath,
        }
      }
    });

    if (_updateStatus == UpdateStatus.updating) {
      return;
    }
    _hasBaseDisconnected = true;
    await BleManager().disconnect(widget.flask);
    BleManager().updateScanResultListener(isPause: true);
    _initiateBLEUpgrade();
  }

  void _initiateBLEUpgrade() {
    if (_hasUpdatedBLE) {
      _initiateMCUUpdate();
      return;
    }
    if (widget.blePath == null) {
      _initiateMCUUpdate();
      return;
    }
    _updateType = UpdateType.ble;
    _cyclesCount = widget.cycleNumber;
    _startScanTry();
  }

  Future<void> _onBLEUpdated() async {
    _hasUpdatedBLE = true;
    BleManager().updateFirmwareLog(widget.flask, 'ble');
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
    if (widget.mcuPath == null) {
      _initiateImageUpdates();
      return;
    }
    _updateType = UpdateType.mcu;
    _cyclesCount = widget.cycleNumber;
    _startScanTry();
  }

  Future<void> _onMCUUpdated() async {
    _hasUpdatedMCU = true;

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
    if (imagePaths.isEmpty) {
      BleManager().updateFirmwareLog(widget.flask, 'image');
      BleManager().updateFirmwareLog(widget.flask, 'mcu');
      _onFullFirmwareUpdateCompleted(isSuccess: true);
      return;
    }
    _updateType = UpdateType.images;
    _cyclesCount = widget.cycleNumber;
    _startScanTry();
  }

  Future<void> _onImageUpdateCompleted() async {
    BleManager().updateFirmwareLog(widget.flask, 'image');
    BleManager().updateFirmwareLog(widget.flask, 'mcu');
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
      await BleManager().connectFlask(device: widget.flask, connectTime: 5);
    }
  }

  void _disposeBLEUtil() {
    bleUtil.dispose();
  }
}
