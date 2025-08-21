import 'package:echowater/base/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';

class SearchBarView extends StatefulWidget {
  const SearchBarView({
    required this.onFieldSubmitted,
    super.key,
    this.hint = 'Search..',
  });

  final Function(String text) onFieldSubmitted;
  final String hint;

  @override
  _SearchBarViewState createState() => _SearchBarViewState();
}

class _SearchBarViewState extends State<SearchBarView> {
  final FlutterNativeContactPicker _contactPicker = FlutterNativeContactPicker();
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      autocorrect: false,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.color231F20,
        border: InputBorder.none,
        prefixIcon: const Icon(
          Icons.search,
          size: 20,
        ),
        suffixIcon: InkWell(
          onTap: () async {
            final contact = await _contactPicker.selectPhoneNumber();
            if (contact != null) {
              _controller.text = contact.selectedPhoneNumber ?? '';
              widget.onFieldSubmitted(_controller.text.replaceAll(RegExp(r'[-\s]'), ''));
            }
          },
          child: const Icon(
            Icons.person,
            size: 20,
          ),
        ),
        hintText: widget.hint,
      ),
      textInputAction: TextInputAction.search,
      onFieldSubmitted: widget.onFieldSubmitted,
    );
  }
}
