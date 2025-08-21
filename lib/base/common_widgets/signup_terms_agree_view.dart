import 'package:echowater/theme/app_color_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SignUpTermsAgreeView extends StatefulWidget {
  const SignUpTermsAgreeView({required this.onSelectionChanged, super.key});

  final Function(bool)? onSelectionChanged;

  @override
  State<SignUpTermsAgreeView> createState() => _SignUpTermsAgreeViewState();
}

class _SignUpTermsAgreeViewState extends State<SignUpTermsAgreeView> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
      ),
      child: Row(
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              _isSelected = !_isSelected;
              setState(() {});
              widget.onSelectionChanged?.call(_isSelected);
            },
            icon: Icon(
              _isSelected ? Icons.check_box : Icons.check_box_outline_blank,
              color: _isSelected ? Theme.of(context).primaryColor : Theme.of(context).colorScheme.primaryElementColor,
            ),
          ),
          const SizedBox(
            width: 2,
          ),
          Expanded(
              child: Text.rich(
                  textAlign: TextAlign.left,
                  TextSpan(
                      text: 'I accept',
                      style: GoogleFonts.quicksand(
                          color: Theme.of(context).colorScheme.primaryElementColor, fontSize: 16, fontWeight: FontWeight.w400),
                      children: <InlineSpan>[
                        const WidgetSpan(
                          child: Padding(
                            padding: EdgeInsets.only(left: 5),
                          ),
                        ),
                        WidgetSpan(
                          child: InkWell(
                            onTap: () {
                              launchUrlString('https://echowater.com/policies/privacy-policy');
                            },
                            child: Text('Terms and Conditions',
                                style: GoogleFonts.quicksand(
                                    color: Theme.of(context).colorScheme.primaryElementColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    decoration: TextDecoration.underline)),
                          ),
                        ),
                        WidgetSpan(
                          child: Text('.',
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primaryElementColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400)),
                        ),
                      ]))),
        ],
      ),
    );
  }
}
