import 'package:flutter/material.dart';

import '../oc_bug_reporter.dart';

class FloatingBugReporter extends StatefulWidget {
  const FloatingBugReporter({required this.imageString, super.key});
  final String imageString;

  @override
  State<FloatingBugReporter> createState() => _FloatingBugReporterState();
}

class _FloatingBugReporterState extends State<FloatingBugReporter> {
  @override
  void initState() {
    super.initState();
  }

  void _createLog() {
    OCBugReporterService().openLogger();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: _createLog,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.transparent,
            boxShadow: [
              BoxShadow(
                  offset: const Offset(1, 1),
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 5,
                  spreadRadius: 1)
            ]),
        width: 80,
        height: 80, // Adjust the width as needed
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(widget.imageString),
        ),
      ),
    );
  }
}
