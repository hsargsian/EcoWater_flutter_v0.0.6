import 'dart:async';

import 'package:echowater/base/common_widgets/upgrade_firmware_dialog.dart';
import 'package:echowater/core/services/walkthrough_manager/walk_through_manager.dart';
import 'package:echowater/oc_libraries/ble_service/flask_manager.dart';
import 'package:echowater/screens/auth/countdown/count_down_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../../base/common_widgets/snackbar/snackbar_style.dart';
import '../../base/utils/utilities.dart';
import '../../core/domain/domain_models/flask_domain.dart';
import '../../core/injector/injector.dart';
import '../../core/services/api_cache_retry_service/api_cache_retry_service.dart';
import '../../core/services/push_notification_service/push_notification_service.dart';
import '../../oc_libraries/ble_service/ble_manager.dart';
import '../device_management/bloc/device_management_bloc.dart';
import '../flask_module/ota_upgrade_screen/ota_upgrade_screen.dart';
import '../splash_screen/splash_screen.dart';
import 'bloc/dashboard_bloc.dart';
import 'sub_views/echo_water_bottom_navigation_bar.dart';
import 'sub_views/tab_contents.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();

  static Route<void> route() {
    return MaterialPageRoute<void>(
        settings: const RouteSettings(name: '/dashboard'),
        builder: (_) => const DashboardScreen());
  }
}

class _DashboardScreenState extends State<DashboardScreen>
    with
        TickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<DashboardScreen>,
        WidgetsBindingObserver {
  TabController? _tabBarController;

  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey();
  List<DashboardPageItem> _tabItems = [];
  var _currentIndex = 0;
  Timer? _searchTimer;

  late final DeviceManagementBloc _deviceManagementBloc;
  late final DashboardBloc _bloc;

  BluetoothAdapterState? _previousBleState;

  @override
  void initState() {
    Injector.instance<FlaskManager>().initialize();
    _deviceManagementBloc = Injector.instance<DeviceManagementBloc>();
    _bloc = Injector.instance<DashboardBloc>();
    Injector.instance<ApiCacheRetryService>().instantiate();
    BleManager().isUserLoggedIn = true;
    _bloc.add(FetchSystemAccessEvent());

    if (_bloc.systemAccessInfo != null) {
      _setUpScreen();
    }

    super.initState();
    WidgetsBinding.instance.addObserver(this);

    BleManager().onStateChanged = (state) {
      if (_previousBleState != null && _previousBleState == state) {
        return;
      }
      if (_previousBleState == BluetoothAdapterState.turningOn &&
          state == BluetoothAdapterState.on &&
          _bloc.bleDevicesWrapper.flasks.isNotEmpty) {
        _initateSearch(_bloc.bleDevicesWrapper.flasks);
      }
      _previousBleState = state;
    };

    BleManager().initiateFlaskFetchSearchAndPair = () {
      _bloc.add(FetchAllFlasksEvent(true));
    };
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      initiateProcessesOnResume();
    }
  }

  Future<void> initiateProcessesOnResume() async {
    final myConnectedFlasks = BleManager().connectedDevices.keys;
    final flaksKeys =
        _bloc.bleDevicesWrapper.flasks.map((item) => item.serialId);
    final sameItems = Set.from(myConnectedFlasks).containsAll(flaksKeys) &&
        Set.from(flaksKeys).containsAll(myConnectedFlasks);
    if (sameItems) {
      BleManager().requestAllBatchData();
    } else {
      unawaited(_initateSearch(_bloc.bleDevicesWrapper.flasks));
    }
  }

  Future<void> _initPush() async {
    await Injector.instance<PushNotificationService>().initService();
    Future.delayed(const Duration(seconds: 10), _updateDevice);
  }

  void _updateDevice() {
    Injector.instance<DeviceManagementBloc>().add(UpdateDeviceEvent());
  }

  void _setUpTabBar() {
    _tabItems = DashboardTabs.getTabs().map((e) {
      return DashboardPageItem(
        tab: e,
      );
    }).toList();
    _tabBarController = TabController(
      length: _tabItems.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _searchTimer?.cancel();
    BleManager().stopScan();
    _tabBarController?.dispose();

    super.dispose();
  }

  void _setUpScreen() {
    _deviceManagementBloc.add(AddInitialPushNotificationListenerEvent());
    _initPush();
    _setUpTabBar();
    _updateDevice();
    _bloc.add(FetchAllFlasksEvent(true));
  }

  void _onPageChange(DashboardTabs tab) {
    _currentIndex = tab.itemIndex;
    WalkThroughManager().currentTab = tab;
    _tabBarController?.animateTo(tab.itemIndex);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PopScope(
      canPop: false,
      child: BlocConsumer<DashboardBloc, DashboardState>(
        bloc: _bloc,
        listener: (context, state) {
          _onStateChanged(state);
        },
        builder: (context, state) {
          if (state is DashboardIdleState) {
            return const SplashPage(
              isCallInitState: false,
            );
          }

          return _configureDashboard();
        },
      ),
    );
  }

  Widget _systemAccessableWidget() {
    return Scaffold(
      drawerEnableOpenDragGesture: false,
      key: _scaffoldState,
      drawerEdgeDragWidth: 250,
      body: TabBarView(
        controller: _tabBarController,
        physics: const NeverScrollableScrollPhysics(),
        children: _tabItems.map((item) => item.tab.content()).toList(),
      ),
      bottomNavigationBar: SafeArea(
        child: EchoWaterBottomNavigationBar(
          tabs: _tabItems,
          user: null,
          currentIndex: _currentIndex,
          onTabClicked: _onPageChange,
        ),
      ),
    );
  }

  Widget _configureDashboard() {
    if (_bloc.systemAccessInfo == null) {
      return Container();
    }
    if (_bloc.systemAccessInfo!.canAccessSystem) {
      return _systemAccessableWidget();
    } else {
      return CountDownScreen(targetDate: _bloc.systemAccessInfo!.accessDate());
    }
  }

  @override
  bool get wantKeepAlive => true;

  void _onStateChanged(DashboardState state) {
    if (state is MessageState) {
      Utilities.showSnackBar(context, state.message, state.snackbarStyle);
    } else if (state is FetchedMyFlasksState) {
      _initateSearch(state.flasks);
    } else if (state is FetchedSystemAccessState) {
      if (state.systemAccessInfo.canAccessSystem) {
        _setUpScreen();
      }
    } else if (state is FlaskFirmwareInfoFetchedState) {
      if (state.firmwareInfo.hasUpgrade) {
        Utilities.showBottomSheet(
            isDismissable: false,
            widget: UpgradeFirmwareDialog(
              firmware: state.firmwareInfo,
              flask: state.flask,
              openUpgradeScreen: (blePath, mcuPath, imageLibraryPaths) {
                Navigator.pop(context);
                _openUpgradeScreen(
                    state.flask, blePath, mcuPath, imageLibraryPaths);
              },
            ),
            context: context);
      }
    }
  }

  Future<void> _openUpgradeScreen(FlaskDomain flask, String? blePath,
      String? mcuPath, List<String>? imageLibraryPaths) async {
    if (mounted) {
      await Navigator.push(
          context,
          OtaUpgradeScreen.route(
            flask: flask,
            cycleNumber: 5,
            blePath: blePath,
            mcuPath: mcuPath,
            imageLibraryPath: imageLibraryPaths,
            refreshFlaskVersion: (didUpgradeFirmware) {},
          ));
    }
  }

  Future<void> _onSearchCompleted() async {
    if (!mounted) {
      return;
    }
    final list = BleManager().scanResultsListing;
    BleManager().onDataLogRequestChange?.call('', false);
  }

  Future<void> _initateSearch(List<FlaskDomain> flasks) async {
    final isInitialized = await BleManager().initService();
    if (isInitialized.first) {
      final isBluetoothConnected =
          await FlutterBluePlus.adapterState.first == BluetoothAdapterState.on;

      BleManager().updateMyFlasks(flasks.map((item) => item.serialId).toList());
      if (isBluetoothConnected) {
        if (flasks.isEmpty) {
          return;
        }
        if (mounted) {
          setState(() {});
          _searchTimer =
              Timer(const Duration(seconds: 2), _initializeBleAndSearch);
        }
      }
    } else if (isInitialized.second != null) {
      if (mounted) {
        Utilities.showSnackBar(
            context, isInitialized.second!, SnackbarStyle.error);
      }
    }
  }

  Future<void> _initializeBleAndSearch() async {
    BleManager()
        .onDataLogRequestChange
        ?.call('Connecting your flasks...', true);
    BleManager().stopScan();
    BleManager().onSearchComplete = _onSearchCompleted;
    BleManager().onCycleRun = (device, ppmGenerated) {
      _bloc.add(StartCycleEvent(device, ppmGenerated));
    };

    BleManager().onFlaskMCURead = (device, mcu) {
      if (_currentIndex == 0) {
        _bloc.add(FetchFlaskFirmwareVersionEvent(
            bleVersion: null,
            mcuVersion: mcu,
            flaskSerialId: device.identifier));
      }
    };

    BleManager().startScan(connectTime: 7);
  }
}
