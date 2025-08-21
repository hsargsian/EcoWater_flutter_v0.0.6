import 'package:echowater/base/app_specific_widgets/app_boxed_container.dart';
import 'package:echowater/base/common_widgets/buttons/normal_button_text.dart';
import 'package:echowater/base/common_widgets/snackbar/snackbar_style.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/base/utils/utilities.dart';
import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../base/common_widgets/navbar/echo_water_nav_bar.dart';
import '../../../base/common_widgets/text_fields/app_textfield.dart';
import '../../../base/utils/colors.dart';

int throttleSliderValue = 1400;

class BleConfiguratorScreen extends StatefulWidget {
  const BleConfiguratorScreen({super.key});

  @override
  State<BleConfiguratorScreen> createState() => _BleConfiguratorScreenState();

  static Route<void> route() {
    return MaterialPageRoute<void>(
        settings: const RouteSettings(name: '/BleConfiguratorScreen'),
        builder: (_) => const BleConfiguratorScreen());
  }
}

class _BleConfiguratorScreenState extends State<BleConfiguratorScreen> {
  final _sFieldController = TextEditingController();
  final _txFieldController = TextEditingController();
  final _rxFieldController = TextEditingController();
  final _pref = const FlutterSecureStorage();
  @override
  void initState() {
    super.initState();
    _populateData();
  }

  Future<void> _populateData() async {
    final serviceUUid = await _pref.read(key: 'serviceUUId') ?? '';
    final txCharUUid = await _pref.read(key: 'txCharUUid') ?? '';
    final rxCharUUid = await _pref.read(key: 'rxCharUUid') ?? '';
    _sFieldController.text = serviceUUid;
    _txFieldController.text = txCharUUid;
    _rxFieldController.text = rxCharUUid;
  }

  void _onDoneButtonClick() {
    Utilities.dismissKeyboard();
    if (_sFieldController.text.isInvalidUUId) {
      Utilities.showSnackBar(context,
          'Please provide valid 128 bits service uuid', SnackbarStyle.error);
      return;
    }
    if (_txFieldController.text.isInvalidUUId) {
      Utilities.showSnackBar(
          context,
          'Please provide valid 128 bits transfer characteristics uuid',
          SnackbarStyle.error);
      return;
    }
    if (_rxFieldController.text.isInvalidUUId) {
      Utilities.showSnackBar(
          context,
          'Please provide valid 128 bits read characteristics uuid',
          SnackbarStyle.error);
      return;
    }
    _pref
      ..write(key: 'serviceUUId', value: _sFieldController.text)
      ..write(key: 'txCharUUid', value: _txFieldController.text)
      ..write(key: 'rxCharUUid', value: _rxFieldController.text)
      ..write(key: 'configuredBLE', value: '1');
    Utilities.showSnackBar(context, 'BLE configured. Please go and scan again',
        SnackbarStyle.success);
    Navigator.pop(context);
  }

  Widget _formFieldsView() {
    return Column(
      children: [
        const SizedBox(
          height: 16,
        ),
        AppTextField.textField(
            context: context,
            hint: 'Service UUID'.localized,
            verticalPadding: 10,
            validator: () => null,
            textCapitalization: TextCapitalization.none,
            controller: _sFieldController,
            backgroundColor: AppColors.transparent,
            hasMandatoryBorder: true,
            textColor: Theme.of(context).colorScheme.primaryElementColor,
            borderColor: AppColors.tertiaryElementColor),
        const SizedBox(
          height: 16,
        ),
        AppTextField.textField(
            context: context,
            hint: 'TX Character UUID'.localized,
            verticalPadding: 10,
            validator: () => null,
            textCapitalization: TextCapitalization.none,
            controller: _txFieldController,
            backgroundColor: AppColors.transparent,
            hasMandatoryBorder: true,
            textColor: Theme.of(context).colorScheme.primaryElementColor,
            borderColor: AppColors.tertiaryElementColor),
        const SizedBox(
          height: 16,
        ),
        AppTextField.textField(
            context: context,
            hint: 'Rx Character UUID'.localized,
            verticalPadding: 10,
            validator: () => null,
            textCapitalization: TextCapitalization.none,
            controller: _rxFieldController,
            backgroundColor: AppColors.transparent,
            hasMandatoryBorder: true,
            textColor: Theme.of(context).colorScheme.primaryElementColor,
            borderColor: AppColors.tertiaryElementColor),
        const SizedBox(
          height: 16,
        ),
        Slider(
          value: throttleSliderValue.toDouble(),
          onChanged: (value) {
            throttleSliderValue = value.toInt();
            setState(() {});
          },
          min: 100,
          max: 5000,
          divisions: 490,
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
            'Command Gap Time:  $throttleSliderValue milliseconds (${throttleSliderValue / 1000} seconds)'),
        const SizedBox(
          height: 16,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EchoWaterNavBar(
          child: SizedBox(
        height: 120,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              NormalTextButton(
                title: 'ProfileEditScreen_cancel'.localized,
                fontSize: 20,
                onClick: () {
                  Navigator.pop(context);
                },
              ),
              Expanded(
                  child: Text(
                'BLE Configurator'.localized,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              )),
              NormalTextButton(
                title: 'ProfileEditScreen_Done'.localized,
                fontSize: 20,
                onClick: () {
                  _onDoneButtonClick();
                },
              ),
            ],
          ),
        ),
      )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            AppBoxedContainer(
              backgroundColor: Theme.of(context).colorScheme.tertiary,
              borderSides: const [AppBorderSide.top, AppBorderSide.bottom],
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'BLEConfiguratorScreen_message'.localized.localized,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .secondaryElementColor,
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      '`65010001-1D0F-47D7-B149-C2FDF0006916`'.localized,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      'This is a sample service UUID'.localized,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .secondaryElementColor,
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'After updating you can go and rescan and fetch devices'
                          .localized,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .secondaryElementColor,
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    _formFieldsView(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
