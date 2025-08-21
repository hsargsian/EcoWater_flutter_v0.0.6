import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FirebaseLocalizationLoader extends AssetLoader {
  late final FirebaseFirestore fireStore;

  final _flutterSecuredStorage = const FlutterSecureStorage();

  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) async {
    final localizationKey = locale.languageCode;
    final localizationDoc =
        (await fireStore.collection('localization').doc(localizationKey).get())
            .data();

    if (localizationDoc == null) {
      return {};
    }
    if (!localizationDoc.containsKey('path')) {
      return {};
    }

    final path = localizationDoc['path'] as String;
    final Timestamp lastModifiedTime = localizationDoc['timestamp'];
    if (path.isEmpty) {
      return {};
    }

    final localizationItem =
        await _flutterSecuredStorage.read(key: 'Localization$localizationKey');
    final savedLastModifiedTime = await _flutterSecuredStorage.read(
        key: 'Localization${locale.languageCode}-Time');

    if (localizationItem == null || savedLastModifiedTime == null) {
      final jsonMap = await _loadFromPath(path, isRemote: true);
      await _saveDetails(path, lastModifiedTime, locale);
      return jsonMap;
    } else {
      if (DateTime.parse(savedLastModifiedTime)
              .compareTo(lastModifiedTime.toDate()) ==
          -1) {
        final jsonMap = _loadFromPath(path, isRemote: true);
        await _saveDetails(path, lastModifiedTime, locale);
        return jsonMap;
      } else {
        return _loadFromPath(path);
      }
    }
  }

  Future<Map<String, dynamic>> _loadFromPath(String path,
      {bool isRemote = false}) async {
    FileInfo? fileInfo;
    if (isRemote) {
      fileInfo = await DefaultCacheManager().downloadFile(path);
    } else {
      fileInfo = await DefaultCacheManager().getFileFromCache(path);
      fileInfo ??= await DefaultCacheManager().downloadFile(path);
    }
    final jsonString = await fileInfo.file.readAsString();
    final jsonData = jsonDecode(jsonString);
    return jsonData;
  }

  Future<void> _saveDetails(
      String path, Timestamp lastModifiedTime, Locale locale) async {
    await _flutterSecuredStorage.write(
        key: 'Localization${locale.languageCode}-Time',
        value: lastModifiedTime.toDate().toString());
    await _flutterSecuredStorage.write(
        key: 'Localization${locale.languageCode}', value: path);
    return Future.value();
  }
}
