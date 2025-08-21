import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'oc_bug_reporter.dart';
import 'oc_image_editor_screen.dart';

class OCBugReporterScreen extends StatefulWidget {
  const OCBugReporterScreen({this.image, this.onBugReporterClosed, super.key});
  final Uint8List? image;
  final Function? onBugReporterClosed;

  @override
  State<OCBugReporterScreen> createState() => _OCBugReporterScreenState();

  static Route<void> route(Uint8List? image, Function? onBugReporterClosed) {
    return MaterialPageRoute<void>(
        settings: const RouteSettings(name: '/ocbugreporter'),
        builder: (_) => OCBugReporterScreen(
              image: image,
              onBugReporterClosed: onBugReporterClosed,
            ));
  }
}

class _OCBugReporterScreenState extends State<OCBugReporterScreen> {
  final TextEditingController _titleTextController = TextEditingController();
  final TextEditingController _descriptionTextController =
      TextEditingController();

  Uint8List? image;

  @override
  void initState() {
    image = widget.image;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
          foregroundColor: Colors.white,
          title: Text(
            'Report a technical problem',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
              widget.onBugReporterClosed?.call();
            },
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                textAlign: TextAlign.center,
                "If a problem or product isn't working correctly, you can give feedback to help us the make app better.",
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            if (image == null)
              Container()
            else
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child: Column(
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        child: Image.memory(
                          image!,
                          width: 150,
                          height: 250,
                          fit: BoxFit.cover,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              OCImageEditorScreen.route(image!, (p0) {
                                image = p0;
                                setState(() {});
                              }));
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            'Edit Image',
                            style: TextStyle(color: Colors.red, fontSize: 14),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              textAlign: TextAlign.left,
              textAlignVertical: TextAlignVertical.top,
              controller: _titleTextController,
              autocorrect: false,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
              cursorColor: Colors.black,
              decoration: InputDecoration(
                fillColor: Colors.transparent,
                filled: true,
                floatingLabelAlignment: FloatingLabelAlignment.start,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                isDense: true,
                alignLabelWithHint: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                labelText: 'Title',
                labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimary
                        .withValues(alpha: 0.4)),
                hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimary
                        .withValues(alpha: 0.4)),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              textAlign: TextAlign.left,
              textAlignVertical: TextAlignVertical.top,
              controller: _descriptionTextController,
              autocorrect: false,
              maxLines: 10,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
              cursorColor: Colors.black,
              decoration: InputDecoration(
                fillColor: Colors.transparent,
                filled: true,
                floatingLabelAlignment: FloatingLabelAlignment.start,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                isDense: true,
                alignLabelWithHint: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                labelText:
                    "Breifly explain what happened or what's not working",
                labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimary
                        .withValues(alpha: 0.4)),
                hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimary
                        .withValues(alpha: 0.4)),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            MaterialButton(
              color: Theme.of(context).colorScheme.primary,
              minWidth: double.maxFinite,
              onPressed: _onSubmitButtonClick,
              height: 45,
              child: Text(
                'Report Problem',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
          ]),
        ),
      ),
    );
  }

  void _onSubmitButtonClick() {
    if (_titleTextController.text.isEmpty ||
        _descriptionTextController.text.isEmpty) {
      // Utilities.showSnackBar(
      //     context, 'Title and description are required', SnackbarStyle.error);
      return;
    }

    OCBugReporterService().createLog(
        image, _titleTextController.text, _descriptionTextController.text);
    Navigator.pop(context);
    widget.onBugReporterClosed?.call();
  }
}
