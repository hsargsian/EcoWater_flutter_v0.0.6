import 'package:flutter/material.dart';

mixin LoaderHelper {
  static late BuildContext _dialogContext;

  static void showLoader(BuildContext context) {
    _dialogContext = context;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const AlertDialog(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [CircularProgressIndicator()],
          ),
        );
      },
    );
  }

  static void hideLoader() {
    Navigator.of(_dialogContext).pop();
  }
}
