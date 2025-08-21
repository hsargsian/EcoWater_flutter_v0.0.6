import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../console_log_stream.dart';

class LogScreen extends StatefulWidget {
  const LogScreen({super.key});

  @override
  State<LogScreen> createState() => _LogScreenState();

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const LogScreen());
  }
}

class _LogScreenState extends State<LogScreen> {
  StreamSubscription<List<String>>? _dataStreamSubscription;

  List<String> items = [];
  @override
  void initState() {
    super.initState();
    items = ConsoleLogStream().myList;
    setState(() {});
    _dataStreamSubscription?.cancel();
    _dataStreamSubscription = ConsoleLogStream().dataStream.listen((newData) {
      setState(() {
        items = newData;
      });
    });
  }

  @override
  void dispose() {
    _dataStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        _navBar(),
        Expanded(
            child: Stack(children: [
          StreamBuilder<List<String>>(
            stream: ConsoleLogStream().dataStream,
            builder: (context, snapshot) {
              return ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(items[index]),
                  );
                },
              );
            },
          ),
          Visibility(
              visible: items.isEmpty,
              child: const Center(
                child: Text('No logs available'),
              ))
        ])),
      ]),
    );
  }

  Widget _navBar() {
    return ColoredBox(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                  color: Colors.white,
                ),
                const Expanded(
                    child: Text(
                  'Screen Log',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                )),
                IconButton(
                    onPressed: _shareLog,
                    icon: const Icon(Icons.share),
                    color: Colors.white),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _shareLog() async {
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/log.txt');
    final sink = file.openWrite();
    for (final element in items) {
      sink.writeln(element);
    }
    await sink.close();
    await Share.shareXFiles([XFile(file.path)]);
  }
}
