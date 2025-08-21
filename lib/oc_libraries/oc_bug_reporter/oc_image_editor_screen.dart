import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_painter/image_painter.dart';

class OCImageEditorScreen extends StatefulWidget {
  const OCImageEditorScreen(
      {required this.image, required this.onImageUpdated, super.key});

  final Uint8List image;
  final void Function(Uint8List) onImageUpdated;

  @override
  _OCImageEditorScreenState createState() => _OCImageEditorScreenState();

  static Route<void> route(
      Uint8List image, Function(Uint8List) onImageUpdated) {
    return MaterialPageRoute<void>(
        settings: const RouteSettings(name: '/OCImageEditorScreen'),
        builder: (_) => OCImageEditorScreen(
              image: image,
              onImageUpdated: onImageUpdated,
            ));
  }
}

class _OCImageEditorScreenState extends State<OCImageEditorScreen> {
  final _imageKey = GlobalKey<ImagePainterState>();
  final _imagePainterController = ImagePainterController();

  Future<void> _saveImage(BuildContext context) async {
    final image = await _imagePainterController.exportImage();
    if (image != null) {
      widget.onImageUpdated.call(image);
    }
    if (!context.mounted) {
      return;
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        title: const Text(
          'Bug Image Edit',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.check,
              color: Colors.white,
            ),
            onPressed: () {
              _saveImage(context);
            },
          )
        ],
      ),
      body: ImagePainter.memory(
        controller: _imagePainterController,
        widget.image,
        key: _imageKey,
        scalable: true,
        textDelegate: TextDelegate(),
      ),
    );
  }
}
