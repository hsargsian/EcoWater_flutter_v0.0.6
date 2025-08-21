import 'dart:async';

import 'package:echowater/base/app_specific_widgets/animating_pulse_lottie_view.dart';
import 'package:echowater/base/common_widgets/buttons/app_button.dart';
import 'package:echowater/base/common_widgets/buttons/normal_button_text.dart';
import 'package:echowater/base/common_widgets/image_widgets/app_image_view.dart';
import 'package:echowater/base/common_widgets/navbar/echo_water_nav_bar.dart';
import 'package:echowater/base/common_widgets/text_fields/app_textfield.dart';
import 'package:echowater/base/constants/constants.dart';
import 'package:echowater/base/constants/string_constants.dart';
import 'package:echowater/base/utils/animations.dart';
import 'package:echowater/base/utils/colors.dart';
import 'package:echowater/base/utils/images.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/core/injector/injector.dart';
import 'package:echowater/flavor_config.dart';
import 'package:echowater/oc_libraries/ble_service/app_ble_model.dart';
import 'package:echowater/screens/flask_module/flask_personalization_screen/flask_personalization_screen.dart';
import 'package:echowater/screens/flask_module/search_and_pair_screen/bloc/search_and_pair_screen_bloc.dart';
import 'package:echowater/screens/flask_module/search_and_pair_screen/no_devices_found_view.dart';
import 'package:echowater/screens/onboarding_flow/onboarding_item_view.dart';
import 'package:echowater/screens/onboarding_flow/onboarding_model.dart';
import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../base/app_specific_widgets/left_arrow_back_button.dart';
import '../../../base/common_widgets/snackbar/snackbar_style.dart';
import '../../../base/utils/utilities.dart';
import '../../../core/domain/domain_models/flask_domain.dart';
import '../../../core/services/firmware_update_log_report_service.dart';
import '../../../oc_libraries/ble_service/ble_manager.dart';
import '../../auth/authentication/bloc/authentication_bloc.dart';

class SearchAndPairScreen extends StatefulWidget {
  const SearchAndPairScreen(
      {required this.isFromDeviceListing, this.onDeviceAdded, super.key});
  final Function()? onDeviceAdded;
  final bool isFromDeviceListing;

  @override
  State<SearchAndPairScreen> createState() => _SearchAndPairScreenState();

  static Route<void> route(
      {required bool isFromDeviceListing, Function()? onDeviceAdded}) {
    return MaterialPageRoute<void>(
        settings: const RouteSettings(name: '/SearchAndPairScreen'),
        builder: (_) => SearchAndPairScreen(
              isFromDeviceListing: isFromDeviceListing,
              onDeviceAdded: onDeviceAdded,
            ));
  }
}

class _SearchAndPairScreenState extends State<SearchAndPairScreen> {
  SearchAndPairScreenMode _currentMode = SearchAndPairScreenMode.idle;
  Timer? _searchTimer;
  Timer? _pauseTimer;
  final TextEditingController _flaskNameController = TextEditingController();
  AppBleModel? _device;
  late final SearchAndPairScreenBloc _bloc;
  FlaskDomain? _pairedFlask;

  late final FirmwareUpdateLogReportService _logService;
  @override
  void initState() {
    _bloc = Injector.instance<SearchAndPairScreenBloc>();
    BleManager().isUserLoggedIn = true;
    super.initState();
    _logService = Injector.instance<FirmwareUpdateLogReportService>()
      ..addFirmwareUpgradeLogReport(log: {
        'type': 'SEARCH_AND_PAIR',
        'message': 'Opened the screen for Search and Pair'
      });
    _initateSearch();
  }

  Future<void> _initializeBleAndSearch() async {
    BleManager().onSearchComplete = _onSearchCompleted;
    BleManager().startScan();
  }

  Future<void> _onSearchCompleted() async {
    if (!mounted) {
      return;
    }
    final list = BleManager().scanResultsListing;
    _updateState(list.isEmpty
        ? SearchAndPairScreenMode.notfound
        : SearchAndPairScreenMode.found);
  }

  Future<void> _initateSearch() async {
    _logService.addFirmwareUpgradeLogReport(log: {
      'type': 'SEARCH_AND_PAIR',
      'message': 'Cheking if BLE Service initiated'
    });
    final isInitialized = await BleManager().initService();
    if (isInitialized.first) {
      await BleManager().disconnectAllDevices();
      _currentMode = SearchAndPairScreenMode.searching;
      if (mounted) {
        setState(() {});
        _searchTimer =
            Timer(const Duration(seconds: 1), _initializeBleAndSearch);
      }
    } else if (isInitialized.second != null) {
      _logService.addFirmwareUpgradeLogReport(log: {
        'type': 'SEARCH_AND_PAIR',
        'error': true,
        'message': isInitialized.second
      });
      if (mounted) {
        Utilities.showSnackBar(
            context, isInitialized.second!, SnackbarStyle.error);
      }
    }
  }

  void _updateState(SearchAndPairScreenMode mode) {
    _currentMode = mode;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _searchTimer?.cancel();
    _pauseTimer?.cancel();
    BleManager().stopScan();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SearchAndPairScreenBloc, SearchAndPairScreenState>(
        bloc: _bloc,
        listener: (context, state) {
          _onStateChanged(state, context);
        },
        builder: (context, state) {
          return Stack(
            children: [
              _getModeBasedView(),
              _navbar(),
              Visibility(
                  visible: _pairedFlask != null, child: _flaskConnectedView())
            ],
          );
        },
      ),
    );
  }

  void _showFlaskConnectedView(FlaskDomain flask) {
    _pairedFlask = flask;
    setState(() {});
  }

  Widget _flaskConnectedView() {
    return Positioned.fill(
        child: ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          Expanded(
            child: OnBoardingItemView(
                item: OnboardingModel(
                    title: 'Your flask is paired'.localized,
                    description:
                        '${_flaskNameController.text} is now paired with the app. You can view your hydration stats and other bottle information on your dashboard.',
                    image: Images.flaskConnectedImage,
                    topPadding: 0,
                    bottomPadding: 30,
                    buttonTitle: '',
                    showsSkipButton: false,
                    showsBackButton: true,
                    showsPageIndicator: false,
                    backgroundPercentage: 0.2)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: AppButton(
                height: 45,
                hasGradientBackground: true,
                title: 'View Flask Guide'.localized,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                onClick: () {
                  Utilities.launchUrl(Constants.guideLink);
                }),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 15),
            child: Column(
              children: [
                AppButton(
                    height: 45,
                    hasGradientBackground: true,
                    title: 'Done'.localized,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    onClick: () {
                      _pairedFlask?.appBleModelDevice = _device;
                      _logService
                        ..addFirmwareUpgradeLogReport(log: {
                          'type': 'SEARCH_AND_PAIR',
                          'error': false,
                          'message':
                              'Device connected and moving to personalization',
                          'flask': _pairedFlask!.entity.toJson()
                        })
                        ..sendFirmwareUpgradeLogReport();

                      Navigator.push(
                          context,
                          FlaskPersonalizationScreen.route(
                            flask: _pairedFlask!,
                            opensDashboard: !widget.isFromDeviceListing,
                            refreshFlaskList: () {
                              widget.onDeviceAdded?.call();
                              Navigator.pop(context);
                            },
                          ));
                    }),
                // Visibility(
                //   visible: widget.isFromDeviceListing,
                //   child: Padding(
                //     padding: const EdgeInsets.only(top: 10),
                //     child: NormalTextButton(
                //       title: 'Skip for now',
                //       onClick: () {
                //         widget.onDeviceAdded?.call();
                //         _logService
                //           ..logReport(log: {
                //             'type': 'SEARCH_AND_PAIR',
                //             'error': false,
                //             'message':
                //                 'Device connected and skinging personalization',
                //             'flask': _pairedFlask!.entity.toJson()
                //           })
                //           ..sendLogReport();
                //         Navigator.pop(context);
                //       },
                //     ),
                //   ),
                // )
              ],
            ),
          )
        ],
      ),
    ));
  }

  void _onStateChanged(SearchAndPairScreenState state, BuildContext context) {
    if (state is AddedNewFlaskState) {
      _logService.addFlask(flask: state.flask);
      _showFlaskConnectedView(state.flask);
    } else if (state is SearchAndPairScreenApiErrorState) {
      Utilities.showSnackBar(
          context, state.errorMessage, SnackbarStyle.validationError);
    }
  }

  void _openDashboard(bool flag) {
    Injector.instance<AuthenticationBloc>()
        .add(AuthenticationCheckUserSessionEvent());
  }

  PreferredSizeWidget _navbar() {
    return EchoWaterNavBar(
        backgroundColor: Colors.transparent,
        child: SizedBox(
          height: 100,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LeftArrowBackButton(
                onButtonPressed: () {
                  if (_currentMode ==
                      SearchAndPairScreenMode.pairedAndNameUpdate) {
                    BleManager().disconnectModel(_device);
                  }
                  _logService.sendFirmwareUpgradeLogReport();
                  Navigator.pop(context);
                },
              ),
              Visibility(
                visible: false,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15, right: 10),
                  child: Text('Skip'.localized,
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          fontSize: 16, color: Theme.of(context).primaryColor)),
                ),
              )
            ],
          ),
        ));
  }

  void _onItemTapped() {
    if (_device == null) {
      return;
    }
    _updateState(SearchAndPairScreenMode.pairing);
    BleManager().onDeviceConnected = (device, connected) {
      if (connected) {
        _flaskNameController.text = device.bleDevice.advName;
        _logService.addFirmwareUpgradeLogReport(log: {
          'type': 'SEARCH_AND_PAIR',
          'error': false,
          'message': 'Device connected. Updating name for device',
          'additional_info': {
            'device advertising address': device.identifier,
          }
        });
        _updateState(SearchAndPairScreenMode.pairedAndNameUpdate);
      } else {
        _logService.addFirmwareUpgradeLogReport(log: {
          'type': 'SEARCH_AND_PAIR',
          'error': true,
          'message': 'Device not connected.',
          'additional_info': {
            'device advertising address': device.identifier,
          }
        });
        _device = null;
        _flaskNameController.text = '';
        _updateState(SearchAndPairScreenMode.pairUnSuccessful);
      }
    };
    BleManager().connect(device: _device!, isAlreadyConnected: false);
  }

  Widget _getModeBasedView() {
    switch (_currentMode) {
      case SearchAndPairScreenMode.idle:
      case SearchAndPairScreenMode.searching:
        return Center(
            child: AnimatingPulseLottieView(
          path: Animations.pinkAnimation,
          text: 'SearchAndPairScreen_Searching'.localized,
        ));
      case SearchAndPairScreenMode.notfound:
        return NoDevicesFoundView(
          title: 'NoDeviceFoundView_notFound'.localized,
          onSearchAgainClick: () {
            _initateSearch();
          },
        );

      case SearchAndPairScreenMode.found:
        final items = BleManager().scanResultsListing;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 10, bottom: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  Text(
                    'Devices found',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontFamily: StringConstants.fieldGothicTestFont,
                        fontWeight: FontWeight.w400),
                  ),
                  Text(
                    'Select a device to pair',
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                        border: Border.all(
                          width: 0.5,
                          color: BleManager().isConnected(items[index])
                              ? Colors.green
                              : Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(15)),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: InkWell(
                      onTap: () {
                        _device = items[index];
                        _onItemTapped();
                      },
                      child: Row(
                        children: [
                          const AppImageView(
                            width: 80,
                            height: 80,
                            cornerRadius: 0,
                            placeholderImage: Images.sampleWaterBottlePngImage,
                            placeholderFit: BoxFit.contain,
                          ),
                          const SizedBox(
                            width: 3,
                          ),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      items[index].bleDevice.advName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                              fontFamily: StringConstants
                                                  .fieldGothicTestFont,
                                              fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Visibility(
                                      visible: FlavorConfig.isNotProduction(),
                                      child: Text('Rssi: ${items[index].rssi}'))
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                items[index].identifier,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondaryElementColor),
                              ),
                            ],
                          ))
                        ],
                      ),
                    ),
                  );
                },
                itemCount: items.length,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: Column(
                children: [
                  Text(
                    'SearchAndPairScreen_didntFindDevice'.localized,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Try turning off your system bluetooth and turning it back on.'
                        .localized,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .secondaryElementColor),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  AppButton(
                      title: 'NoDeviceFoundView_Search_Again'.localized,
                      onClick: () {
                        _initateSearch();
                      }),
                  const SizedBox(
                    height: 5,
                  ),
                  NormalTextButton(
                    title: 'skip'.localized,
                    onClick: () {
                      _openDashboard(false);
                    },
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                ],
              ),
            )
          ],
        );
      case SearchAndPairScreenMode.noPermission:
        return Container(
          height: 200,
          color: Colors.red,
        );
      case SearchAndPairScreenMode.pairing:
        return AnimatingPulseLottieView(
          path: Animations.blueAnimation,
          text: 'SearchAndPairScreen_Pairing'.localized,
        );
      case SearchAndPairScreenMode.pairedAndNameUpdate:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  Text('SearchAndPairScreen_Name_Your_Flask'.localized),
                  const SizedBox(
                    height: 10,
                  ),
                  Text('SearchAndPairScreen_name_display_on_app'.localized),
                  const SizedBox(
                    height: 20,
                  ),
                  AppTextField.textField(
                      context: context,
                      hint:
                          'SearchAndPairScreen_FlaskNamePlaceholder'.localized,
                      verticalPadding: 10,
                      validator: () => null,
                      textCapitalization: TextCapitalization.none,
                      controller: _flaskNameController,
                      keyboardType: TextInputType.name,
                      backgroundColor: AppColors.transparent,
                      hasMandatoryBorder: true,
                      textColor:
                          Theme.of(context).colorScheme.primaryElementColor,
                      borderColor: AppColors.tertiaryElementColor),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: AppButton(
                    title: 'SearchAndPairScreen_Save'.localized,
                    onClick: () {
                      if (_device != null) {
                        Utilities.dismissKeyboard();
                        _bloc
                          ..add(SetFlaskToPairEvent(
                              _device!, _flaskNameController.text))
                          ..add(AddNewFlaskEvent());
                      }
                    }),
              )
            ],
          ),
        );
      case SearchAndPairScreenMode.paired:
        final description =
            '''${_bloc.currentUser?.name ?? ''} ${_bloc.deviceName} ${"SearchAndPairScreen_nowPaired".localized}''';
        return Stack(
          children: [
            OnBoardingItemView(
                item: OnboardingModel(
                    title: 'SearchAndPairScreen_Your_flask_is_paired'.localized,
                    description: description,
                    image: Images.deviceOnboarding_3,
                    topPadding: 0,
                    bottomPadding: 180,
                    buttonTitle: '',
                    showsBackButton: false,
                    showsSkipButton: false,
                    showsPageIndicator: false)),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      AppButton(
                        title: 'SearchAndPairScreen_ViewDashboard'.localized,
                        onClick: () {
                          _bloc.add(AddNewFlaskEvent());
                        },
                        height: 45,
                        radius: 30,
                        hasGradientBackground: true,
                        width: MediaQuery.of(context).size.width * 0.9,
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                ))
          ],
        );
      case SearchAndPairScreenMode.pairUnSuccessful:
        return NoDevicesFoundView(
          title: 'NoDeviceFoundView_notpaired'.localized,
          onSearchAgainClick: () {
            _initateSearch();
          },
        );
    }
  }
}

enum SearchAndPairScreenMode {
  idle,
  searching,
  notfound,
  found,
  pairing,
  noPermission,
  pairedAndNameUpdate,
  paired,
  pairUnSuccessful
}
