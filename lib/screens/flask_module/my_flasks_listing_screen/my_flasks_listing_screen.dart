import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:echowater/base/app_specific_widgets/app_bottom_action_sheet_view.dart';
import 'package:echowater/base/app_specific_widgets/app_boxed_container.dart';
import 'package:echowater/base/app_specific_widgets/flask_options_view.dart';
import 'package:echowater/base/common_widgets/image_widgets/app_image_view.dart';
import 'package:echowater/base/constants/string_constants.dart';
import 'package:echowater/base/utils/date_utils.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/core/domain/domain_models/flask_domain.dart';
import 'package:echowater/core/domain/domain_models/flask_option.dart';
import 'package:echowater/flavor_config.dart';
import 'package:echowater/oc_libraries/ble_service/ble_manager.dart';
import 'package:echowater/screens/flask_module/clean_flask_screen/clean_flask_screen.dart';
import 'package:echowater/screens/flask_module/flask_personalization_screen/flask_personalization_screen.dart';
import 'package:echowater/screens/flask_module/search_and_pair_screen/search_and_pair_screen.dart';
import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:share_plus/share_plus.dart';

import '../../../base/app_specific_widgets/left_arrow_back_button.dart';
import '../../../base/common_widgets/alert/alert.dart';
import '../../../base/common_widgets/empty_state_view.dart';
import '../../../base/common_widgets/loader/loader.dart';
import '../../../base/common_widgets/navbar/echo_water_nav_bar.dart';
import '../../../base/common_widgets/navbar/nav_bar.dart';
import '../../../base/common_widgets/segmented_control_view/segmented_control_item.dart';
import '../../../base/common_widgets/segmented_control_view/segmented_control_view.dart';
import '../../../base/common_widgets/snackbar/snackbar_style.dart';
import '../../../base/utils/images.dart';
import '../../../base/utils/utilities.dart';
import '../../../core/domain/domain_models/fetch_style.dart';
import '../../../core/injector/injector.dart';
import 'bloc/my_flasks_listing_screen_bloc.dart';

enum BLELogViewType {
  all,
  received,
  sent;
}

class MyDevicesListingScreen extends StatefulWidget {
  const MyDevicesListingScreen({super.key});

  @override
  State<MyDevicesListingScreen> createState() => _MyDevicesListingScreenState();

  static Route<void> route() {
    return MaterialPageRoute<void>(
        settings: const RouteSettings(name: '/MyDevicesListingScreen'),
        builder: (_) => const MyDevicesListingScreen());
  }
}

List<Map<String, dynamic>> dataLog = [];

class _MyDevicesListingScreenState extends State<MyDevicesListingScreen> {
  final _refreshController = RefreshController();
  late final MyFlasksListingScreenBloc _bloc;
  bool _showsLoader = false;
  BLELogViewType _logViewType = BLELogViewType.all;

  bool _filtersBatchDataOnly = false;

  int _connetionRetryCount = 0;
  bool _isDisposed = false;

  List<Map<String, dynamic>> _curatedList() {
    if (_logViewType == BLELogViewType.all) {
      return dataLog;
    } else if (_logViewType == BLELogViewType.received) {
      return dataLog.where((item) => !item['is_sent']).toList();
    } else {
      return dataLog.where((item) => item['is_sent']).toList();
    }
  }

  @override
  void initState() {
    _bloc = Injector.instance<MyFlasksListingScreenBloc>();
    super.initState();
    _bloc.add(FetchMyFlasksEvent(FetchStyle.normal));
    _setUpLogListener();
    BleManager().onFlaskStateChanges = _onStateChangedMessageReceived;
  }

  Future<void> _onStateChangedMessageReceived(bool isConnected) async {
    await Future.delayed(const Duration(seconds: 3), () {
      _bloc.bleDevicesWrapper.updateBLEModel();
      if (mounted) {
        setState(() {});
      }
    });
  }

  void updateLoader(bool value) {
    if (!mounted) {
      return;
    }
    setState(() {
      _showsLoader = value;
    });
  }

  @override
  void dispose() {
    BleManager().onNewLog = null;
    _isDisposed = true;
    BleManager().onSearchComplete = null;
    BleManager().onFlaskStateChanges = null;
    super.dispose();
  }

  void _setUpLogListener() {
    BleManager().onNewLog =
        (data, command, isSent, additionalInfo, isBatchData) {
      if (isSent) {
        dataLog.insert(0, {
          'data': data,
          'original_data': bytesToHexString(data),
          'command': command,
          'is_sent': isSent,
          'time': DateTime.now()
              .humanReadableDateString(hasShortHad: false, format: 'hh:mm:ss'),
          'additionalInfo': additionalInfo
        });
        if (mounted) {
          setState(() {});
        }
      } else {
        if (_filtersBatchDataOnly) {
          if (isBatchData) {
            dataLog.insert(0, {
              'data': data,
              'original_data': bytesToHexString(data),
              'command': command,
              'is_sent': isSent,
              'time': DateTime.now().humanReadableDateString(
                  hasShortHad: false, format: 'hh:mm:ss'),
              'additionalInfo': additionalInfo
            });
            if (mounted) {
              setState(() {});
            }
          }
        } else {
          dataLog.insert(0, {
            'data': data,
            'original_data': bytesToHexString(data),
            'command': command,
            'is_sent': isSent,
            'time': DateTime.now().humanReadableDateString(
                hasShortHad: false, format: 'hh:mm:ss'),
            'additionalInfo': additionalInfo
          });
          if (mounted) {
            setState(() {});
          }
        }
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
            appBar: EchoWaterNavBar(
                child: NavBar(
              navStyle: NavStyle.singleLined,
              leftButton: const LeftArrowBackButton(),
              navTitle: 'MyFlaskListingScreen_myDevices'.localized,
              textColor: Theme.of(context).colorScheme.primaryElementColor,
              sideMenuItems: [
                IconButton(
                    onPressed: () {
                      _bloc.add(TurnOnBluetoothEvent(isGoToNextPage: true));
                    },
                    icon: const Icon(Icons.add))
              ],
            )),
            body: BlocConsumer<MyFlasksListingScreenBloc,
                MyFlasksListingScreenState>(
              bloc: _bloc,
              listener: (context, state) {
                _onStateChanged(state);
              },
              builder: (context, state) {
                return Column(
                    children: [Expanded(child: _mainContent()), _logView()]);
              },
            )),
        BlocBuilder<MyFlasksListingScreenBloc, MyFlasksListingScreenState>(
          bloc: _bloc,
          builder: (context, state) {
            return Visibility(
              visible: state is FetchingMyFlasksState || _showsLoader,
              child: Positioned.fill(
                  child: Container(
                color: Theme.of(context)
                    .scaffoldBackgroundColor
                    .withValues(alpha: 0.5),
              )),
            );
          },
        ),
        BlocBuilder<MyFlasksListingScreenBloc, MyFlasksListingScreenState>(
          bloc: _bloc,
          builder: (context, state) {
            return Visibility(
              visible: state is FetchingMyFlasksState || _showsLoader,
              child: Center(
                child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        color:
                            Theme.of(context).colorScheme.primaryElementColor,
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Loader(),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Please wait...',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryElementColorInverted),
                        )
                      ],
                    )),
              ),
            );
          },
        )
      ],
    );
  }

  String bytesToHexString(List<int> bytes) {
    final buffer = StringBuffer();
    for (final byte in bytes) {
      buffer.write(byte.toRadixString(16).padLeft(2, '0'));
    }
    return buffer.toString().toUpperCase(); // Convert to uppercase if needed
  }

  Future<String> writeToFile(String content) async {
    final directory = await getTemporaryDirectory();
    final path = '${directory.path}/my_data.txt';
    final file = File(path);

    await file.writeAsString(content);
    return path;
  }

  String listToString() {
    return jsonEncode(dataLog);
  }

  Widget _logView() {
    if (FlavorConfig.isProduction() && !kDebugMode) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'BLE Logs:',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                InkWell(
                  onTap: () async {
                    dataLog = [];
                    if (mounted) {
                      setState(() {});
                    }
                  },
                  child: Text(
                    'Clear Log',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.red),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    final path = await writeToFile(listToString());
                    if (!context.mounted) {
                      return;
                    }
                    await Share.shareXFiles([
                      XFile(path),
                    ],
                        text: 'BLE Log',
                        subject: 'SAA',
                        sharePositionOrigin: Rect.fromLTWH(
                            0,
                            0,
                            MediaQuery.of(context).size.width,
                            MediaQuery.of(context).size.height / 2));
                  },
                  child: Text(
                    'Share',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.green),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Visibility(
              visible: _logViewType == BLELogViewType.received,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    const Expanded(child: Text('Filter only batch data')),
                    Switch(
                        value: _filtersBatchDataOnly,
                        onChanged: (value) {
                          _filtersBatchDataOnly = value;
                          setState(() {});
                        })
                  ],
                ),
              ),
            ),
            SegmentedControlView(
              items: [
                SegmentedControlItem(
                    onTapped: () {
                      _logViewType = BLELogViewType.all;
                      setState(() {});
                    },
                    unselectedBackgroundColor: Theme.of(context)
                        .colorScheme
                        .secondaryElementColor
                        .withValues(alpha: 0),
                    selectedBackgroundColor:
                        Theme.of(context).colorScheme.primary,
                    isSelected: _logViewType == BLELogViewType.all,
                    index: 0,
                    title: 'All'),
                SegmentedControlItem(
                    onTapped: () {
                      _logViewType = BLELogViewType.received;
                      setState(() {});
                    },
                    isSelected: _logViewType == BLELogViewType.received,
                    index: 0,
                    unselectedBackgroundColor: Theme.of(context)
                        .colorScheme
                        .secondaryElementColor
                        .withValues(alpha: 0),
                    selectedBackgroundColor:
                        Theme.of(context).colorScheme.primary,
                    title: 'Received'),
                SegmentedControlItem(
                    onTapped: () {
                      _logViewType = BLELogViewType.sent;
                      setState(() {});
                    },
                    isSelected: _logViewType == BLELogViewType.sent,
                    index: 0,
                    unselectedBackgroundColor: Theme.of(context)
                        .colorScheme
                        .secondaryElementColor
                        .withValues(alpha: 0),
                    selectedBackgroundColor:
                        Theme.of(context).colorScheme.primary,
                    title: 'Sent'),
              ],
              size: 38,
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  final item = _curatedList()[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.3),
                    child: Row(
                      children: [
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                '${item['is_sent'] ? 'Sent' : 'Received'}: ${item['data']}'),
                            if (item['is_sent'])
                              Text('Sent Command: ${item['command']}'),
                            Text(
                                'Original Hex Data Sent: ${item['original_data']}'),
                            if (item.containsKey('additionalInfo'))
                              Text(
                                  'Additional Infop: ${item['additionalInfo'] as String? ?? ''}'),
                          ],
                        )),
                        Text(item['time'])
                      ],
                    ),
                  );
                },
                itemCount: _curatedList().length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _mainContent() {
    return Stack(
      children: [
        Visibility(
          visible: _bloc.bleDevicesWrapper.flasks.isEmpty,
          child: Center(
            child: EmptyStateView(
              title: 'MyFlaskListingScreen_noDevices'.localized,
              tags: const [],
            ),
          ),
        ),
        SmartRefresher(
          controller: _refreshController,
          enablePullUp: _bloc.bleDevicesWrapper.hasMore,
          onLoading: () async {
            await Utilities.vibrate();
            _bloc.add(FetchMyFlasksEvent(FetchStyle.loadMore));
          },
          onRefresh: () async {
            await Utilities.vibrate();
            _bloc.add(FetchMyFlasksEvent(FetchStyle.pullToRefresh));
          },
          child: ListView.builder(
              padding: const EdgeInsets.only(top: 10),
              itemCount: _bloc.bleDevicesWrapper.flasks.length,
              itemBuilder: (context, index) {
                return _singleAppBleDeviceItem(
                    flask: _bloc.bleDevicesWrapper.flasks[index]);
              }),
        )
      ],
    );
  }

  Widget _singleAppBleDeviceItem({required FlaskDomain flask}) {
    return InkWell(
      onTap: () {},
      child: AppBoxedContainer(
        borderSides: const [AppBorderSide.bottom, AppBorderSide.top],
        borderWidth: 0.5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: Row(
                children: [
                  const AppImageView(
                    placeholderImage: Images.sampleWaterBottlePngImage,
                    placeholderWidth: 60,
                    height: 80,
                    cornerRadius: 0,
                    placeholderHeight: 80,
                    placeholderFit: BoxFit.contain,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: Text(
                              flask.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontFamily:
                                          StringConstants.fieldGothicTestFont),
                            )),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text('Sn. ${flask.serialId}',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color:
                                        Theme.of(context)
                                            .colorScheme
                                            .secondaryElementColor,
                                    fontFamily:
                                        StringConstants.fieldGothicTestFont)),
                        const SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  IconButton(
                      iconSize: 30,
                      color: Theme.of(context).colorScheme.primaryElementColor,
                      onPressed: () {
                        _showMoreOptionForFlask(flask);
                      },
                      icon: const Icon(Icons.more_vert))
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onStartCycle(BuildContext context, FlaskDomain flask) async {
    // Send wake up command first
    final wakeUpResponse = await BleManager().sendData(
      flask,
      FlaskCommand.wakeUp,
      FlaskCommand.wakeUp.commandData.addingCRC(),
    );
    if (wakeUpResponse.isEmpty) {
    } else {
      if (!context.mounted) {
        return;
      }
      setState(() {});
      Utilities.showSnackBar(context, wakeUpResponse, SnackbarStyle.error);
    }

    // Then send start cycle command
    final respose = await BleManager().sendData(flask, FlaskCommand.startCycle,
        FlaskCommand.startCycle.commandData.addingCRC());
    if (respose.isEmpty) {
    } else {
      if (!context.mounted) {
        return;
      }
      setState(() {});
      Utilities.showSnackBar(context, respose, SnackbarStyle.error);
    }
  }

  Future<void> _onStopCycle(BuildContext context, FlaskDomain flask) async {
    // Send wake up command first
    final wakeUpResponse = await BleManager().sendData(
      flask,
      FlaskCommand.wakeUp,
      FlaskCommand.wakeUp.commandData.addingCRC(),
    );
    if (wakeUpResponse.isEmpty) {
    } else {
      if (!context.mounted) {
        return;
      }
      setState(() {});
      Utilities.showSnackBar(context, wakeUpResponse, SnackbarStyle.error);
    }

    final response = await BleManager().sendData(flask, FlaskCommand.stopCycle,
        FlaskCommand.stopCycle.commandData.addingCRC());
    if (response.isEmpty) {
    } else {
      if (!context.mounted) {
        return;
      }
      setState(() {});
      Utilities.showSnackBar(context, response, SnackbarStyle.error);
    }
  }

  Future<void> _onConnectFlask(FlaskDomain? flask) async {
    if (flask == null) {
      updateLoader(false);
      return;
    }

    final wakeUpResponse = await BleManager().sendData(
      flask,
      FlaskCommand.wakeUp,
      FlaskCommand.wakeUp.commandData.addingCRC(),
    );
    if (wakeUpResponse.isEmpty) {
    } else {
      if (!context.mounted) {
        return;
      }
      setState(() {});
      Utilities.showSnackBar(context, wakeUpResponse, SnackbarStyle.error);
    }

    BleManager().updateMyFlasks(_bloc.bleDevicesWrapper.flaskIds);

    BleManager().onSearchComplete = () {
      if (_isDisposed) {
        return;
      }
      updateLoader(false);
      final didConnect =
          BleManager().connectedDevices.keys.contains(flask.serialId);
      if (didConnect) {
        flask.appBleModelDevice =
            BleManager().connectedDevices[flask.serialId]?.appBleDevice;

        if (context.mounted) {
          Utilities.showSnackBar(context, 'Your flask connected successfully',
              SnackbarStyle.success);
        }
      } else {
        if (_connetionRetryCount == 3) {
          _showConnectionErrorAlert();
          _connetionRetryCount = 0;
        } else {
          _connetionRetryCount += 1;
          _onConnectFlask(flask);
          return;
        }
      }
    };
    await BleManager().connectFlask(device: flask, connectTime: 5);
  }

  void _showConnectionErrorAlert() {
    final alert = Alert();
    alert.showAlert(
        context: context,
        title: 'Connection Failed'.localized,
        message:
            'Seems like there is problem connecting the flask. Please check if your bluetooth is on.\n\nAlso check if your flask is connected to any other phone, it needs to be disconnected from the other device first.'
                .localized,
        actionWidget: alert.getDefaultSingleButtons(
          buttonTitle: 'Ok'.localized,
          onButtonClick: () {
            Navigator.pop(context);
          },
        ));
  }

  void _showMoreOptionForFlask(FlaskDomain flask) {
    // needs to be var
    // ignore: prefer_const_declarations
    final options = <FlaskOption>[];
    if (!flask.hasAppBleModel) {
      options.add(FlaskOption.connect);
    } else {
      options.add(FlaskOption.personalizeFlask);
      if (BleManager()
          .cycleRunningFlasks
          .contains(flask.appBleModelDevice!.identifier)) {
        options.add(FlaskOption.stopCycle);
      } else {
        options.add(FlaskOption.startCycle);
      }
      options.add(FlaskOption.cleanFlask);
      if (kDebugMode) {
        options
          ..add(FlaskOption.sendTime)
          ..add(FlaskOption.requestBatch)
          ..add(FlaskOption.clearDataLog);
      }
    }

    Utilities.showBottomSheet(
        widget: FlaskOptionView(
          flaskOptions: options,
          flaskName: flask.name,
          onUnpairButtonClick: () {
            Navigator.pop(context);
            _showUnPairActionSheet(flask);
          },
          onItemClick: (option) {
            Navigator.pop(context);
            switch (option) {
              case FlaskOption.connect:
                _bloc.add(
                    TurnOnBluetoothEvent(isGoToNextPage: false, flask: flask));

              case FlaskOption.startCycle:
                _onStartCycle(context, flask);
              case FlaskOption.stopCycle:
                _onStopCycle(context, flask);
              case FlaskOption.personalizeFlask:
                Navigator.push(
                    context,
                    FlaskPersonalizationScreen.route(
                      flask: flask,
                      opensDashboard: false,
                      refreshFlaskList: () {
                        _bloc.add(FetchMyFlasksEvent(FetchStyle.pullToRefresh));
                      },
                    ));
              case FlaskOption.cleanFlask:
                Navigator.push(context, CleanFlaskScreen.route(flask: flask));
              case FlaskOption.sendTime:
                final manager = BleManager().getManager(flask);
                if (manager != null) {
                  BleManager().updateInternetBasedTime(manager);
                }
              case FlaskOption.requestBatch:
                final manager = BleManager().getManager(flask);
                if (manager != null) {
                  BleManager().requestBatchData(manager);
                }
              case FlaskOption.clearDataLog:
                final manager = BleManager().getManager(flask);
                if (manager != null) {
                  BleManager().clearDataLog(manager);
                }
            }
          },
        ),
        context: context);
  }

  void _showUnPairActionSheet(FlaskDomain device) {
    Utilities.showBottomSheet(
        widget: AppBottomActionsheetView(
          title: "${"Unpair".localized} ${device.name}?",
          message: 'unpair_message'.localized,
          posiitiveButtonTitle: 'Confirm'.localized,
          negativeButtonTitle: 'Cancel'.localized,
          onNegativeButtonClick: () {
            Navigator.pop(context);
          },
          onPositiveButtonClick: () {
            Navigator.pop(context);
            if (device.id.isNotEmpty) {
              _bloc.add(DeleteMyFlaskEvent(device));
            }
          },
        ),
        context: context);
  }

  void _onStateChanged(MyFlasksListingScreenState state) {
    if (state is MyFlasksScreenApiErrorState) {
      Utilities.showSnackBar(context, state.errorMessage, SnackbarStyle.error);
    } else if (state is FetchedMyFlasksState) {
      _refreshController
        ..loadComplete()
        ..refreshCompleted();
      _connectFlasksIfNotConnected();
    } else if (state is StartFlaskSuccessState) {
      Utilities.showSnackBar(context, state.message, SnackbarStyle.success);
    } else if (state is TurnOnBluetoothState) {
      if (state.errorMessage != null) {
        updateLoader(false);
        Utilities.showSnackBar(
            context, state.errorMessage ?? '', SnackbarStyle.error);
      }
      if (state.isGoToNextPage) {
        _checkBLEAndNavigateToSearchAndPair();
      } else {
        _onConnectFlask(state.flask);
      }
    }
  }

  void _connectFlasksIfNotConnected() {
    BleManager().updateMyFlasks(_bloc.bleDevicesWrapper.flaskIds);
    BleManager().startScan(connectTime: 10);
  }

  Future<void> _checkBLEAndNavigateToSearchAndPair() async {
    final bleCheckResponse =
        await Utilities.checkBLEState(showsAlert: true, context: context);
    if (!bleCheckResponse.first) {
      if (bleCheckResponse.second != null) {
        if (!mounted) {
          return;
        }
        Utilities.showSnackBar(
            context, bleCheckResponse.second!, SnackbarStyle.error);
      }
      return;
    }
    if (!mounted) {
      return;
    }
    unawaited(Navigator.push(
        context,
        SearchAndPairScreen.route(
          isFromDeviceListing: true,
          onDeviceAdded: () {
            _bloc.add(FetchMyFlasksEvent(FetchStyle.normal));
          },
        )));
  }
}
