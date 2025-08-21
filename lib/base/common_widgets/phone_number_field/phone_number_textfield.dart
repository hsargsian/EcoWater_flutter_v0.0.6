import 'package:country_picker/country_picker.dart';
import 'package:echowater/base/utils/strings.dart';
import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/app_styles.dart';
import '../../utils/colors.dart';
import '../buttons/country_selection_button.dart';
import '../text_fields/app_textfield.dart';

class PhoneNumberPickerTextField extends StatefulWidget {
  const PhoneNumberPickerTextField(
      {required this.hasError,
      required this.text,
      required this.phoneNumberController,
      required this.showsContactPicker,
      required this.onSubmitted,
      super.key,
      this.onFieldSubmitted});

  final TextEditingController phoneNumberController;
  final bool hasError;
  final bool showsContactPicker;
  final String text;
  final Function(String countryCode, String phoneNumber, String countryName)? onSubmitted;
  final Function(String, String)? onFieldSubmitted;

  @override
  State<PhoneNumberPickerTextField> createState() => PhoneNumberPickerTextFieldState();
}

class PhoneNumberPickerTextFieldState extends State<PhoneNumberPickerTextField> {
  late final TextEditingController _phoneNumberController;
  Country _selectedCountry = Country.parse('US');
  final List<Country> _allCountries = CountryService().getAll();

  @override
  void initState() {
    _phoneNumberController = widget.phoneNumberController;
    super.initState();
  }

  String getPhoneNumber() {
    if (_phoneNumberController.text.isEmpty) {
      return '';
    }
    // return '+${_selectedCountry.phoneCode}${_phoneNumberController.text}';
    return _phoneNumberController.text;
  }

  String getCountryName() {
    return _selectedCountry.name;
  }

  String getCountryCode() {
    return _selectedCountry.phoneCode;
  }

  void setPhoneNumberAndCountry(String phoneNumber, String countryName) {
    // final phoneNumberModel = PhoneNumberModel.fromNumber(phoneNumber, _allCountries);
    _selectedCountry = Country.parse(countryName);
    _phoneNumberController.text = phoneNumber;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AppTextField.textField(
      context: context,
      hint: 'Phone Number',
      validator: () => null,
      backgroundColor: AppColors.transparent,
      hasMandatoryBorder: true,
      textColor: Theme.of(context).colorScheme.primaryElementColor,
      borderColor: AppColors.tertiaryElementColor,
      controller: _phoneNumberController,
      keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
      ],
      hasError: widget.hasError,
      textCapitalization: TextCapitalization.none,
      prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: CountrySelectionButton(
            countryCode: '+${_selectedCountry.phoneCode}',
            countryImage: _selectedCountry.flagEmoji,
            width: 80,
            onClick: _showCountryPickerView,
            textStyle: Theme.of(context).textTheme.bodySmall!,
          )),
      onFieldSubmitted: (p0) {
        widget.onSubmitted?.call(_selectedCountry.phoneCode, _phoneNumberController.text, _selectedCountry.name);
      },
    );
  }

  void _showCountryPickerView() {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      countryListTheme: CountryListThemeData(
        flagSize: 25,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        textStyle: GoogleFonts.quicksand(
            fontWeight: FontWeight.w500, fontSize: 15, color: Theme.of(context).colorScheme.primaryElementColor),
        bottomSheetHeight: MediaQuery.of(context).size.height * 0.75,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        inputDecoration: InputDecoration(
          labelText: 'Search'.localized,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          hintText: 'Search'.localized,
          prefixIcon: Icon(
            Icons.search,
            color: Theme.of(context).primaryColor,
          ),
          border: AppStyles.outlinedInputBorder(),
        ),
      ),
      onSelect: (country) {
        _selectedCountry = country;
        setState(() {});
      },
    );
  }
}
