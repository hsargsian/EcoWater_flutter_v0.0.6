import 'dart:async';
import 'dart:io';

import 'package:echowater/base/app_specific_widgets/led_color_view.dart';
import 'package:echowater/base/common_widgets/buttons/app_button.dart';
import 'package:echowater/base/common_widgets/buttons/normal_button_text.dart';
import 'package:echowater/base/common_widgets/snackbar/snackbar_style.dart';
import 'package:echowater/base/constants/constants.dart';
import 'package:echowater/base/utils/images.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/base/utils/utilities.dart';
import 'package:echowater/core/domain/domain_models/flask_domain.dart';
import 'package:echowater/core/injector/injector.dart';
import 'package:echowater/flavor_config.dart';
import 'package:echowater/screens/flask_module/flask_personalization_screen/bloc/flask_personalization_bloc.dart';
import 'package:echowater/screens/flask_module/led_color_selector_screen/led_color_selector_screen.dart';
import 'package:echowater/screens/flask_module/ota_upgrade_screen/ota_upgrade_screen.dart';
import 'package:echowater/theme/app_color_theme.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../../../base/app_specific_widgets/app_boxed_container.dart';
import '../../../base/common_widgets/alert/alert.dart';
import '../../../base/common_widgets/loader/loader.dart';
import '../../../base/common_widgets/navbar/echo_water_nav_bar.dart';
import '../../../base/common_widgets/navbar/nav_bar.dart';
import '../../../base/common_widgets/text_fields/app_textfield.dart';
import '../../../base/constants/string_constants.dart';
import '../../../base/utils/colors.dart';
import '../../../core/domain/domain_models/flask_option.dart';
import '../../../oc_libraries/ble_service/ble_manager.dart';
import '../../auth/authentication/bloc/authentication_bloc.dart';
import 'flask_upgrade_screen.dart';

class FlaskPersonalizationScreen extends StatefulWidget {
  const FlaskPersonalizationScreen(
      {required this.flask,
      required this.opensDashboard,
      this.refreshFlaskList,
      super.key});

  final FlaskDomain flask;
  final Function()? refreshFlaskList;
  final bool opensDashboard;

  @override
  State<FlaskPersonalizationScreen> createState() =>
      _FlaskPersonalizationScreenState();

  static Route<void> route(
      {required FlaskDomain flask,
      required bool opensDashboard,
      Function()? refreshFlaskList}) {
    return MaterialPageRoute<void>(
        settings: const RouteSettings(name: '/FlaskPersonalizationScreen'),
        builder: (_) => FlaskPersonalizationScreen(
              flask: flask,
              refreshFlaskList: refreshFlaskList,
              opensDashboard: opensDashboard,
            ));
  }
}

class _FlaskPersonalizationScreenState
    extends State<FlaskPersonalizationScreen> {
  final TextEditingController _flaskNameTxtController = TextEditingController();
  late final FlaskPersonalizationBloc _bloc;
  double _currentVolumeValue = Constants.defaultFlaskVolume.toDouble();
  int _currentWakeUpValue = Constants.defaultWakeFromSleepTime;

  bool _isDownloadingFirmware = false;
  bool _canShowUpgradeButton = true;

  @override
  void initState() {
    _bloc = Injector.instance<FlaskPersonalizationBloc>();
    _bloc
      ..add(SetFlaskDetailEvent(flask: widget.flask))
      ..add(FlaskPersonalizationSettingsEvent());
    super.initState();
    _fetchFlaskFirmwareVersion();
  }

  void _fetchFlaskFirmwareVersion() {
    print('fetchFlaskFirmwareVersion');
    final manager = BleManager().getManager(widget.flask);
    if (manager != null) {
      print('🔍 BLE Manager found for flask: ${widget.flask.name}');
      print('📱 BLE Version: ${manager.bleVersion}');
      print('🔧 MCU Version: ${manager.mcuVersion}');
      print('🆔 Flask ID: ${widget.flask.id}');

      _bloc.add(FetchFlaskFirmwareVersionEvent(
          mcuVersion: manager.mcuVersion, bleVersion: manager.bleVersion));
    } else {
      print('❌ No BLE Manager found for flask: ${widget.flask.name}');
      print('🆔 Flask ID: ${widget.flask.id}');
      // Try with null versions to see if API accepts them
      _bloc.add(
          FetchFlaskFirmwareVersionEvent(mcuVersion: null, bleVersion: null));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FlaskPersonalizationBloc, FlaskPersonalizationState>(
      bloc: _bloc,
      listener: (context, state) {
        _onStateChanged(state, context);
      },
      builder: (context, state) {
        return _bloc.hasInitialized
            ? PopScope(
                canPop: false,
                child: Scaffold(
                  appBar: EchoWaterNavBar(
                      child: NavBar(
                    navStyle: NavStyle.singleLined,
                    navTitle: _bloc.flask.name,
                    textColor:
                        Theme.of(context).colorScheme.primaryElementColor,
                    sideMenuItems: [
                      BlocBuilder<FlaskPersonalizationBloc,
                          FlaskPersonalizationState>(
                        bloc: _bloc,
                        builder: (context, state) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: state is FlaskPersonalizationChangingState ||
                                    _isDownloadingFirmware
                                ? const Loader()
                                : NormalTextButton(
                                    title: 'Done'.localized,
                                    onClick: () {
                                      _updateFlask(navigatesBack: true);
                                    },
                                  ),
                          );
                        },
                      )
                    ],
                  )),
                  body: SingleChildScrollView(
                      child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      AppBoxedContainer(
                        borderSides: const [AppBorderSide.bottom],
                        borderWidth: 1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Column(
                            children: [
                              Text(
                                'FlaskPersonalizationScreen_personalizeText'
                                    .localized,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                        fontFamily:
                                            StringConstants.fieldGothicTestFont,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primaryElementColor),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              AppTextField.textField(
                                context: context,
                                hint: 'FlaskPersonalizationScreen_flaskName'
                                    .localized,
                                validator: () => null,
                                textCapitalization: TextCapitalization.none,
                                controller: _flaskNameTxtController,
                                backgroundColor: AppColors.transparent,
                                hasMandatoryBorder: true,
                                borderColor: AppColors.tertiaryElementColor,
                                textColor: Theme.of(context)
                                    .colorScheme
                                    .primaryElementColor,
                              ),
                              const SizedBox(
                                height: 10,
                              )
                            ],
                          ),
                        ),
                      ),
                      if (_bloc.personalizationSettings.hasLedLightSettings)
                        _ledLightSettingsView(),
                      if (_bloc.personalizationSettings.hasVolumeControls)
                        _volumeControlView(),
                      if (_bloc.personalizationSettings.hasLedModeSettings)
                        _ledScreenModeView(),
                      if (_bloc.personalizationSettings.hasSleepWakeSettings)
                        _wakeFromSleepControlView(),
                      if (_bloc.firmwareInfo != null &&
                          widget.flask.hasUpgradeVersion(_bloc.firmwareInfo) &&
                          _canShowUpgradeButton)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: Opacity(
                            opacity: _isDownloadingFirmware ? 0.3 : 1.0,
                            child: AppButton(
                                title: _isDownloadingFirmware
                                    ? 'Downloading Firmware... Please wait'
                                    : 'Upgrade',
                                onClick: () {
                                  _onUpgradeButtonClick();
                                }),
                          ),
                        ),
                      if (FlavorConfig.isNotProduction())
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: Opacity(
                            opacity: _isDownloadingFirmware ? 0.3 : 1.0,
                            child: AppButton(
                                title: 'Upgrade Using Local Files',
                                onClick: () async {
                                  if (!_isDownloadingFirmware) {
                                    await _initiateLocalUpgradeProcess();
                                  }
                                }),
                          ),
                        ),
                      _versionInfoView()
                    ],
                  )),
                ),
              )
            : Container();
      },
    );
  }

  void _updateFlask({required bool navigatesBack}) {
    final manager = BleManager().getManager(widget.flask);
    _bloc.add(UpdateFlaskRequestEvent(
        _bloc.flask.id,
        _bloc.isLightMode,
        _flaskNameTxtController.text,
        _bloc.selectedColor.colorId,
        _bloc.flaskVolume,
        manager?.bleVersion,
        manager?.mcuVersion?.toString(),
        navigatesBack));
  }

  Future<void> _onUpgradeButtonClick() async {
    if (!_isDownloadingFirmware) {
      print('on upgrade button click');

      // Check if we have upgrade paths available
      if (_bloc.hasUpgradesAvailable) {
        print('🚀 Opening FlaskUpgradeScreen with saved upgrade paths');
        _bloc.logStoredUpgradePaths(); // Debug log

        // Open FlaskUpgradeScreen directly with stored upgrade paths
        await _openUpgradeScreenWithStoredPaths();
      } else {
        print('❌ No upgrade paths available');
        // Show message to user that no upgrades are available
        Utilities.showSnackBar(
          context,
          'No firmware upgrades available at this time',
          SnackbarStyle.error, // Changed to error style for red/pink color
        );
      }
    }
  }

  Widget _versionInfoView() {
    final manager = BleManager().getManager(widget.flask);
    if (manager == null) {
      return Container();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Text(
          'Version: ${manager.bleVersion ?? ''}(${manager.mcuVersion ?? ''})'),
    );
  }

  Future<void> _openUpgradeScreen(
      String? blePath, String? mcuPath, List<String>? imageLibraryPaths) async {
    setState(() {
      _isDownloadingFirmware = false;
    });

    if (mounted) {
      // Use upgrade paths from the bloc instead of parameters
      final upgradeData = _bloc.getUpgradeData();

      // Navigate to FlaskUpgradeScreen with data from bloc
      await Navigator.push(
        context,
        FlaskUpgradeScreen.route(
          flask: upgradeData['flask'],
          cycleNumber: upgradeData['cycleNumber'],
          blePath: _bloc.blePath,
          mcuPath: _bloc.mcuPath,
          imageLibraryPaths: _bloc.imagePaths,
          refreshFlaskVersion: (didUpgradeFirmware) {
            _canShowUpgradeButton = !didUpgradeFirmware;
            // Only update flask if firmware upgrade was successful and we have a connected manager
            if (didUpgradeFirmware) {
              final manager = BleManager().getManager(widget.flask);
              if (manager != null) {
                // Wait a bit for the device to stabilize after firmware update
                Future.delayed(const Duration(seconds: 2), () {
                  try {
                    _updateFlask(navigatesBack: false);
                  } catch (e) {
                    print('⚠️ Error updating flask after firmware upgrade: $e');
                    // Don't show error to user as this is just version sync
                  }
                });
              }
            }
          },
          showMockUI: false, // Set to false for real OTA upgrade
        ),
      );

      // Alternative: Navigate to OtaUpgradeScreen if preferred
      // await Navigator.push(
      //     context,
      //     OtaUpgradeScreen.route(
      //       cycleNumber: upgradeData['cycleNumber'],
      //       blePath: _bloc.blePath,
      //       mcuPath: _bloc.mcuPath,
      //       imageLibraryPath: _bloc.imagePaths,
      //       refreshFlaskVersion: (didUpgradeFirmware) {
      //         _canShowUpgradeButton = !didUpgradeFirmware;
      //         _updateFlask(navigatesBack: false);
      //       },
      //     ));
    }
  }

  /// Opens FlaskUpgradeScreen with stored upgrade paths from the bloc
  Future<void> _openUpgradeScreenWithStoredPaths() async {
    print('📱 Opening FlaskUpgradeScreen with stored paths from bloc');

    setState(() {
      _isDownloadingFirmware = false;
    });

    if (mounted) {
      // Get upgrade data from bloc
      final upgradeData = _bloc.getUpgradeData();

      print('🔍 Upgrade data: $upgradeData');
      print('📂 BLE Path: ${_bloc.blePath}');
      print('📂 MCU Path: ${_bloc.mcuPath}');
      print('📂 Image Paths: ${_bloc.imagePaths}');

      // Navigate to FlaskUpgradeScreen with stored data from bloc
      await Navigator.push(
        context,
        FlaskUpgradeScreen.route(
          flask: upgradeData['flask'],
          cycleNumber: upgradeData['cycleNumber'],
          blePath: _bloc.blePath,
          mcuPath: _bloc.mcuPath,
          imageLibraryPaths:
              _bloc.imagePaths.isNotEmpty ? _bloc.imagePaths : null,
          allUpgradeData: _bloc.getAllUpgradeData(), // Pass all upgrade data
          refreshFlaskVersion: (didUpgradeFirmware) {
            _canShowUpgradeButton = !didUpgradeFirmware;
            // Only update flask if firmware upgrade was successful and we have a connected manager
            if (didUpgradeFirmware) {
              final manager = BleManager().getManager(widget.flask);
              if (manager != null) {
                // Wait a bit for the device to stabilize after firmware update
                Future.delayed(const Duration(seconds: 2), () {
                  try {
                    _updateFlask(navigatesBack: false);
                  } catch (e) {
                    print('⚠️ Error updating flask after firmware upgrade: $e');
                    // Don't show error to user as this is just version sync
                  }
                });
              }
            }
          },
          showMockUI: false, // Set to false for real OTA upgrade
        ),
      );
    }
  }

  Future<void> _initiateImageBinDownloadProcess(
      String? blePath, String? mcuPath) async {
    final imagePaths = <String>[];
    if (_bloc.firmwareInfo!.imagePath == null) {
      await _openUpgradeScreen(blePath, mcuPath, null);
    } else {
      for (final singleImagePath in (_bloc.firmwareInfo!.imagePath ?? [])) {
        final downloadedImageBin =
            await DefaultCacheManager().getFileFromCache(singleImagePath);
        if (downloadedImageBin == null) {
          final file =
              await DefaultCacheManager().getSingleFile(singleImagePath);

          final uri = Uri.parse(singleImagePath);
          final originalFileName = uri.pathSegments.last;

          // Get app's temp directory
          final directory = await getTemporaryDirectory();
          final newFilePath = path.join(directory.path, originalFileName);

          // Rename/move the file
          final newFile = File(newFilePath);
          await file.copy(newFilePath);
          imagePaths.add(newFile.path);
        } else {
          imagePaths.add(downloadedImageBin.file.path);
        }
      }
      await _openUpgradeScreen(
          blePath, mcuPath, imagePaths.isEmpty ? null : imagePaths);
    }
  }

  Future<void> _initiateMCUDownloadProcess(String? blePath) async {
    String? mcuPath;
    if (_bloc.firmwareInfo!.mcuPath == null) {
      await _initiateImageBinDownloadProcess(blePath, null);
    } else {
      final downloadedMCUBin = await DefaultCacheManager()
          .getFileFromCache(_bloc.firmwareInfo!.mcuPath!);

      if (downloadedMCUBin == null) {
        final file = await DefaultCacheManager()
            .getSingleFile(_bloc.firmwareInfo!.mcuPath!);

        final uri = Uri.parse(_bloc.firmwareInfo!.mcuPath!);
        final originalFileName = uri.pathSegments.last;

        // Get app's temp directory
        final directory = await getTemporaryDirectory();
        final newFilePath = path.join(directory.path, originalFileName);

        // Rename/move the file
        final newFile = File(newFilePath);
        await file.copy(newFilePath);
        mcuPath = newFile.path;
      } else {
        mcuPath = downloadedMCUBin.file.path;
      }
      await _initiateImageBinDownloadProcess(blePath, mcuPath);
    }
  }

  Future<void> _initiateUpgradeProcess() async {
    print('=== Initiating Upgrade Process ===');
    print('Domain firmwareInfo: ${_bloc.firmwareInfo}');
    print('blePath: ${_bloc.firmwareInfo?.blePath}');
    print('mcuPath: ${_bloc.firmwareInfo?.mcuPath}');

    // Print complete response data for upgrade
    if (_bloc.hasCompleteFirmwareData) {
      print('=== Complete Firmware Data for Upgrade ===');
      print('Raw response: ${_bloc.completeFirmwareResponse}');
      print(
          'Current Version: ${_bloc.firmwareInfoRawResponse?.currentVersion}');
      print('All Image Paths: ${_bloc.firmwareInfoRawResponse?.imagePaths}');
      print(
          'Mandatory Check: ${_bloc.firmwareInfoRawResponse?.mandatoryVersionCheck}');
      print('=========================================');
    }
    print('=======================================');
    // setState(() {
    //   _isDownloadingFirmware = true;
    // });
    // if (_bloc.firmwareInfo?.blePath == null) {
    //   await _initiateMCUDownloadProcess(null);
    // } else {
    //   final blePath = await DefaultCacheManager()
    //       .getFileFromCache(_bloc.firmwareInfo!.blePath!);
    //   if (blePath == null) {
    //     final file = await DefaultCacheManager()
    //         .getSingleFile(_bloc.firmwareInfo!.blePath!);

    //     final uri = Uri.parse(_bloc.firmwareInfo!.blePath!);
    //     final originalFileName = uri.pathSegments.last;

    //     // Get app's temp directory
    //     final directory = await getTemporaryDirectory();
    //     final newFilePath = path.join(directory.path, originalFileName);

    //     // Rename/move the file
    //     final newFile = File(newFilePath);
    //     await file.copy(newFilePath);
    //     await _initiateMCUDownloadProcess(newFile.path);
    //   } else {
    //     await _initiateMCUDownloadProcess(blePath.file.path);
    //   }
    // }
  }

  void _localUpgradeAfterMCU(String? blePath, String? mcuPath) {
    final alert = Alert();
    alert.showAlert(
        context: context,
        title: 'Upgrade Firmware'.localized,
        isWarningAlert: true,
        message: 'Do you want to upgrade images files?'.localized,
        actionWidget: alert.getDefaultTwoButtons(
          context: context,
          firstButtonTitle: 'Yes'.localized,
          lastButtonTitle: 'No',
          onFirstButtonClick: () async {
            Navigator.pop(context);
            final imageLibraryResult = await FilePicker.platform.pickFiles(
              allowMultiple: true,
              type: FileType.custom,
              allowedExtensions: ['bin'],
            );

            if ((imageLibraryResult?.files ?? []).isEmpty) {
              setState(() {
                _isDownloadingFirmware = false;
              });
              Utilities.showSnackBar(
                  context,
                  'Please pick the image library upgrade package bin file',
                  SnackbarStyle.error);
              return;
            } else {
              unawaited(_openUpgradeScreen(
                  blePath,
                  mcuPath,
                  imageLibraryResult!.files
                      .map((item) => item.path!)
                      .toList()));
            }
          },
          onLastButtonClick: () {
            Navigator.pop(context);
            setState(() {
              _isDownloadingFirmware = false;
            });
            if (blePath != null || mcuPath != null) {
              unawaited(_openUpgradeScreen(blePath, mcuPath, null));
            }
          },
        ));
  }

  void _localUpgradeAfterBLE(String? blePath) {
    final alert = Alert();
    alert.showAlert(
        context: context,
        title: 'Upgrade Firmware'.localized,
        isWarningAlert: true,
        message: 'Do you want to upgrade MCU file?'.localized,
        actionWidget: alert.getDefaultTwoButtons(
          context: context,
          firstButtonTitle: 'Yes'.localized,
          lastButtonTitle: 'No',
          onFirstButtonClick: () async {
            Navigator.pop(context);
            final mcuResult = await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: ['bin'],
            );

            if ((mcuResult?.files ?? []).isEmpty) {
              setState(() {
                _isDownloadingFirmware = false;
              });
              Utilities.showSnackBar(
                  context,
                  'Please pick the mcu library upgrade package bin file',
                  SnackbarStyle.error);
              return;
            } else {
              _localUpgradeAfterMCU(blePath, mcuResult!.files.first.path!);
            }
          },
          onLastButtonClick: () {
            Navigator.pop(context);
            _localUpgradeAfterMCU(blePath, null);
          },
        ));
  }

  Future<void> _initiateLocalUpgradeProcess() async {
    setState(() {
      _isDownloadingFirmware = true;
    });

    final alert = Alert();
    alert.showAlert(
        context: context,
        title: 'Upgrade Firmware'.localized,
        isWarningAlert: true,
        message: 'Do you want to upgrade ble file?'.localized,
        actionWidget: alert.getDefaultTwoButtons(
          context: context,
          firstButtonTitle: 'Yes'.localized,
          lastButtonTitle: 'No',
          onFirstButtonClick: () async {
            Navigator.pop(context);
            final bleFile = await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: ['zip'],
            );
            if ((bleFile?.files ?? []).isEmpty) {
              setState(() {
                _isDownloadingFirmware = false;
              });
              Utilities.showSnackBar(
                  context,
                  'Please pick the BLE upgrade package zip file',
                  SnackbarStyle.error);
              return;
            } else {
              _localUpgradeAfterBLE(bleFile!.files.first.path!);
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => FlaskUpgradeScreen()),
              // );
            }
          },
          onLastButtonClick: () {
            Navigator.pop(context);
            _localUpgradeAfterBLE(null);
          },
        ));
  }

  Widget _ledScreenModeView() {
    return AppBoxedContainer(
      borderSides: const [AppBorderSide.bottom],
      borderWidth: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                    child: Text(
                  'FlaskPersonalizationScreen_lcdScreen'.localized,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontFamily: StringConstants.fieldGothicTestFont,
                      color: Theme.of(context).colorScheme.primaryElementColor),
                )),
                Row(
                  children: [
                    Text(
                      _bloc.isLightMode
                          ? 'FlaskPersonalizationScreen_lightMode'.localized
                          : 'FlaskPersonalizationScreen_darkMode'.localized,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Switch(
                        value: _bloc.isLightMode,
                        onChanged: (flag) async {
                          _bloc.add(UpdateFlaskLightMode(isLightMode: flag));

                          // Send wake up command first
                          await BleManager().sendData(
                            widget.flask,
                            FlaskCommand.wakeUp,
                            FlaskCommand.wakeUp.commandData.addingCRC(),
                          );

                          // Then send light/dark mode command
                          await BleManager().sendData(
                              widget.flask,
                              flag
                                  ? FlaskCommand.changeLightMode
                                  : FlaskCommand.changeDarkMode,
                              flag
                                  ? FlaskCommand.changeLightMode.commandData
                                      .addingCRC()
                                  : FlaskCommand.changeDarkMode.commandData
                                      .addingCRC());
                        })
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget _ledLightSettingsView() {
    return AppBoxedContainer(
      borderSides: const [AppBorderSide.bottom],
      borderWidth: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Text(
              'FlaskPersonalizationScreen_ledLight'.localized,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  fontFamily: StringConstants.fieldGothicTestFont,
                  color: Theme.of(context).colorScheme.primaryElementColor),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('FlaskPersonalizationScreen_color'.localized),
                      Text(_bloc.selectedColor.title),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      LedColorView(
                        color: _bloc.selectedColor,
                        selectedColor: _bloc.selectedColor,
                        isLabelShown: false,
                        showsSelectionIcon: false,
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                LedColorSelectorScreen.route(
                                  flask: widget.flask,
                                  selectedColor: _bloc.selectedColor,
                                  onColorSelected: (p0) {
                                    _bloc.add(UpdateFlaskColor(color: p0));
                                  },
                                ));
                          },
                          child: SvgPicture.asset(height: 30, Images.editIcon))
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _volumeControlView() {
    return AppBoxedContainer(
      borderSides: const [AppBorderSide.bottom],
      borderWidth: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Flask Sound Setting'.localized,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontFamily: StringConstants.fieldGothicTestFont,
                        color:
                            Theme.of(context).colorScheme.primaryElementColor),
                  ),
                ),
                Row(
                  children: [
                    Text(_currentVolumeValue == 0 ? 'Off' : 'On'),
                    const SizedBox(
                      width: 8,
                    ),
                    Switch(
                        value: _currentVolumeValue != 0,
                        onChanged: (flag) async {
                          // Send wake up command first
                          await BleManager().sendData(
                            widget.flask,
                            FlaskCommand.wakeUp,
                            FlaskCommand.wakeUp.commandData.addingCRC(),
                          );

                          _bloc.add(UpdateFlaskVolume(volume: flag ? 100 : 0));
                          final command = FlaskCommand.updateVolume.commandData
                            ..add(flag ? 1 : 0);
                          await BleManager().sendData(widget.flask,
                              FlaskCommand.updateVolume, command.addingCRC());
                        }),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _wakeFromSleepControlView() {
    return AppBoxedContainer(
      borderSides: const [AppBorderSide.bottom],
      borderWidth: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Flask Wake Up Settings'.localized,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontFamily: StringConstants.fieldGothicTestFont,
                        color:
                            Theme.of(context).colorScheme.primaryElementColor),
                  ),
                ),
                Text(
                  '$_currentWakeUpValue seconds',
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontFamily: StringConstants.fieldGothicTestFont,
                      color: Theme.of(context).colorScheme.primaryElementColor),
                )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Slider(
              min: 3,
              max: 10,
              value: _currentWakeUpValue.toDouble(),
              onChanged: (val) {
                _currentWakeUpValue = val.toInt();
                setState(() {});
              },
              onChangeEnd: (value) async {
                // Send wake up command first
                await BleManager().sendData(widget.flask, FlaskCommand.wakeUp,
                    FlaskCommand.wakeUp.commandData.addingCRC());

                _bloc.add(
                    UpdateFlaskWakeUpFromSleepTime(seconds: value.toInt()));
                final command = FlaskCommand.wakeFromSleep.commandData
                  ..add(value.toInt());
                await BleManager().sendData(widget.flask,
                    FlaskCommand.wakeFromSleep, command.addingCRC());
              },
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _openDashboard() {
    Injector.instance<AuthenticationBloc>()
        .add(AuthenticationCheckUserSessionEvent());
  }

  void _onStateChanged(FlaskPersonalizationState state, BuildContext context) {
    print('onStateChanged: $state');
    print('~~~~~~~ firmwareInfo: ~~~~~~~~ ${_bloc.firmwareInfo}');

    if (state is FlaskPersonalizationSetState) {
      _flaskNameTxtController.text = _bloc.flask.name;
      _currentVolumeValue = _bloc.flaskVolume;
      _currentWakeUpValue = _bloc.wakeUpFromSleepTime;
      setState(() {});
    } else if (state is FlaskPersonalizationUpdateCompleteState) {
      if (state.navigatesBack) {
        if (widget.opensDashboard) {
          _openDashboard();
        } else {
          widget.refreshFlaskList?.call();
          Navigator.pop(context);
        }
      } else {
        _fetchFlaskFirmwareVersion();
      }
    } else if (state is FlaskPersonalizationApiErrorState) {
      Utilities.showSnackBar(context, state.errorMessage, SnackbarStyle.error);
    } else if (state is FlaskFirmwareRetryingState) {
      print(
          'Retrying firmware fetch: ${state.retryAttempt}/${state.maxAttempts}');
      // Optionally show a snackbar or loading indicator
      // Utilities.showSnackBar(context,
      //   'Retrying firmware check... (${state.retryAttempt}/${state.maxAttempts})',
      //   SnackbarStyle.info);
    } else if (state is FlaskFirmwareInfoFetchedState) {
      print('=== Firmware Info Fetched ===');
      print('Domain firmwareInfo: ${_bloc.firmwareInfo}');

      // Print complete response data
      if (_bloc.hasCompleteFirmwareData) {
        print('Complete firmware response: ${_bloc.completeFirmwareResponse}');
        print('Raw response object: ${_bloc.firmwareInfoRawResponse}');
      }
      print('============================');

      if (_bloc.firmwareInfo != null) {
        print('=== Checking if should show upgrade dialog ===');
        print('firmwareInfo exists: true');
        print('firmwareInfo.hasUpgrade: ${_bloc.firmwareInfo!.hasUpgrade}');
        print(
            'firmwareInfo.currentVersion: ${_bloc.firmwareInfo!.currentVersion}');
        print('firmwareInfo.blePath: ${_bloc.firmwareInfo!.blePath}');
        print('firmwareInfo.mcuPath: ${_bloc.firmwareInfo!.mcuPath}');
        // print('firmwareInfo.mcuVersion: ${_bloc.firmwareInfo!.mcuVersion}');

        if (_bloc.firmwareInfo!.hasUpgrade) {
          print('✅ Showing firmware upgrade dialog');
          // _showFirmwareUpgradeDialog();
        } else {
          print('❌ No upgrades available - dialog not shown');
        }
        print('============================================');
      } else {
        print('❌ firmwareInfo is null - dialog not shown');
      }
    }
  }

  void _showFirmwareUpgradeDialog() {
    print('🔥 _showFirmwareUpgradeDialog() called - Dialog should appear now!');
    final alert = Alert();
    alert.showAlert(
        context: context,
        title: 'Upgrade Firmware'.localized,
        isWarningAlert: true,
        message:
            'There is a new upgradable firmware version available. Please update to get the best experience'
                .localized,
        actionWidget: alert.getDefaultSingleButtons(
          buttonTitle: 'Upgrade'.localized,
          onButtonClick: () {
            Navigator.pop(context);
            _onUpgradeButtonClick();
          },
        ));
  }
}
