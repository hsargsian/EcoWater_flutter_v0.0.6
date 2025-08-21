import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'media_file.dart';
import 'media_picker_config.dart';
import 'media_source.dart';
import 'media_source_picker.dart';
import 'media_type.dart';
import 'media_type_picker.dart';

class MediaPickerService {
  factory MediaPickerService() {
    _instance = _instance ?? MediaPickerService._internal();
    return _instance!;
  }
  MediaPickerService._internal();

  static MediaPickerService? _instance;

  Function(List<MediaFile>)? _onSuccess;
  Function(String?)? _onError;
  List<MediaSource> _sources = [];
  List<MediaType> _types = [];
  final _imagePicker = ImagePicker();
  final _imageCropper = ImageCropper();
  MediaSource? _pickedMediaSource;
  MediaType? _pickedMediaType;
  MediaPickerConfig _config = MediaPickerConfig();

  void initiateMediaPick(
      {required BuildContext context,
      required List<MediaType> types,
      required List<MediaSource> sources,
      required MediaPickerConfig config,
      required Function(List<MediaFile>) onSuccess,
      required Function(String?) onError}) {
    _onError = onError;
    _onSuccess = onSuccess;
    _sources = sources;
    _types = types;
    _config = config;

    if (types.length > 1) {
      _showMediaTypePicker(context: context);
    } else {
      _onTypePicked(types.first, context);
    }
  }

  void _onTypePicked(MediaType type, BuildContext context) {
    _pickedMediaType = type;
    if (_sources.length > 1) {
      _showSourcePicker(context: context);
    } else {
      _onSourcePicked(_sources.first, context);
    }
  }

  Future<void> _onSourcePicked(MediaSource source, BuildContext context) async {
    Navigator.pop(context);
    _pickedMediaSource = source;
    switch (source) {
      case MediaSource.camera:
        final permissionGranted = await _requestPermission(source);

        if (!permissionGranted) {
          _onError?.call('Permission denied');
          return;
        }
        await _pickFromCamera(context);
        break;
      case MediaSource.gallery:
        final permissionGranted = await _requestPermission(source);

        if (!permissionGranted) {
          _onError?.call('Permission denied');
          return;
        }

        await _pickFromGallery(context);
        break;

      case MediaSource.files:
        break;
    }
  }

  Future<void> _pickFromCamera(BuildContext context) async {
    switch (_pickedMediaType!) {
      case MediaType.image:
        final media = await _imagePicker.pickImage(source: ImageSource.camera);

        await _handleImagesForCropping(media, context);

      case MediaType.video:
        final media = await _imagePicker.pickVideo(source: ImageSource.camera);
        _handlePickedMedia(media);
      default:
        break;
    }
  }

  Future<void> _handleImagesForCropping(
      XFile? media, BuildContext context) async {
    if (media == null) {
      _onError?.call('Error fetching image');
      return;
    }
    if (_config.cropsImage) {
      final croppedFile = await _imageCropper.cropImage(
        sourcePath: media.path,
        compressQuality: _config.compressQuality,
        aspectRatio: _config.cropAspectRatio,
        uiSettings: _config.mediaPickerCropSettings?.imageCropperSettings(
          context: context,
        ),
      );
      if (croppedFile == null) {
        _onError?.call('Error fetching image');
        return;
      }
      _handlePickedMedia(XFile(croppedFile.path));
    } else {
      _handlePickedMedia(media);
    }
  }

  Future<void> _pickFromGallery(BuildContext context) async {
    switch (_pickedMediaType!) {
      case MediaType.image:
        final media = await _imagePicker.pickImage(source: ImageSource.gallery);

        await _handleImagesForCropping(media, context);
      case MediaType.video:
        final media = await _imagePicker.pickVideo(source: ImageSource.gallery);
        _handlePickedMedia(media);
      default:
        break;
    }
  }

  void _handlePickedMedia(XFile? media) {
    if (media == null) {
      _onError?.call('Error picking media');
      return;
    }
    _onSuccess?.call([MediaFile(media, _pickedMediaType!)]);
  }

  void _showSourcePicker({required BuildContext context}) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        barrierColor: Theme.of(context).bottomSheetTheme.modalBarrierColor,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(40))),
        context: context,
        isScrollControlled: true,
        builder: (context) => MediaSourcePicker(
              onSourceSelected: (source) {
                _onSourcePicked(source, context);
              },
              sources: _sources,
              config: _config,
            ));
  }

  void _showMediaTypePicker({required BuildContext context}) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        barrierColor: Theme.of(context).bottomSheetTheme.modalBarrierColor,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(40))),
        context: context,
        isScrollControlled: true,
        builder: (context) => MediaTypePicker(
              types: _types,
              config: _config,
              onTypeSelected: (type) {
                Navigator.pop(context);
                _onTypePicked(type, context);
              },
            ));
  }

  Future<bool> _requestPermission(MediaSource source) async {
    var status = PermissionStatus.denied;
    if (Platform.isAndroid) {
      if (source == MediaSource.camera) {
        status = await Permission.camera.request();
      } else {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        if (androidInfo.version.sdkInt <= 32) {
          status = await Permission.storage.request();
        } else {
          status = await Permission.photos.request();
        }
      }
    } else {
      if (source == MediaSource.camera) {
        status = await Permission.camera.request();
      } else {
        status = await Permission.photos.request();
      }
    }
    return status.isGranted || status.isLimited;
  }
}
