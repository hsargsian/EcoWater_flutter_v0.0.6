import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';

import 'floating_bug_reporter/floating_bug_reporter.dart';
import 'oc_bug_reporter.dart';

class OCBugReporterWapperScreen extends StatefulWidget {
  const OCBugReporterWapperScreen(
      {required this.child,
      required this.isProduction,
      required this.navigatorKey,
      required this.imageString,
      required this.listId,
      required this.apiKey,
      super.key});
  final Widget child;
  final bool isProduction;
  final GlobalKey<NavigatorState>? navigatorKey;
  final String imageString;
  final String listId;
  final String apiKey;

  @override
  State<OCBugReporterWapperScreen> createState() =>
      _OCBugReporterWapperScreenState();
}

class _OCBugReporterWapperScreenState extends State<OCBugReporterWapperScreen> {
  double _drawerX = 0;
  double _drawerY = 100;
  double _screenWidth = 0;
  double _screenHeight = 0;

  bool _showBugReporterFloatingWidget = false;
  bool _isInitialized = false;

  @override
  void initState() {
    //ASHWIN
    _showBugReporterFloatingWidget = !widget.isProduction;
    //_showBugReporterFloatingWidget = true;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      setState(() {
        _screenWidth = size.width;
        _screenHeight = size.height;
      });
    });
    _ocBugReporterSetUp();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Screenshot(
            controller: OCBugReporterService().screenshotController,
            child: widget.child),
        _bugReporterView()
      ],
    );
  }

  Future<void> _ocBugReporterSetUp() async {
    await OCBugReporterService().initService(
        key: widget.navigatorKey,
        listId: widget.listId,
        apiKey: widget.apiKey,
        showsOnShake: widget.isProduction);
    OCBugReporterService().showsReporter = (flag) {
      _showBugReporterFloatingWidget = flag && !widget.isProduction;
      // _showBugReporterFloatingWidget = flag;
      setState(() {});
    };
    _isInitialized = true;
    setState(() {});
  }

  Widget _bugReporterView() {
    return Positioned(
      left: _drawerX,
      top: _drawerY,
      child: Material(
        color: Colors.transparent,
        child: Visibility(
          visible: _showBugReporterFloatingWidget && _isInitialized,
          child: GestureDetector(
            onPanUpdate: (details) {
              _drawerX += details.delta.dx;
              _drawerY += details.delta.dy;
              setState(() {});
            },
            onPanEnd: (details) {
              _snapToCorner();
            },
            child: FloatingBugReporter(
              imageString: widget.imageString,
            ),
          ),
        ),
      ),
    );
  }

  void _snapToCorner() {
    setState(() {
      if ((_drawerX < 0) || (_drawerX < _screenWidth / 2)) {
        _drawerX = 0;
      } else if ((_drawerX > _screenWidth - 80) ||
          (_drawerX > _screenWidth / 2)) {
        _drawerX = _screenWidth - 80;
      }
      if (_drawerY < 0) {
        _drawerY = 0;
      } else if (_drawerY > _screenHeight - 80) {
        _drawerY = _screenHeight - 80;
      }
    });
  }
}
