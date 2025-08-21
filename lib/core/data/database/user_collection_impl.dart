import 'dart:convert';

import 'package:hive/hive.dart';

import '../../api/exceptions/custom_exception.dart';
import '../../domain/database/app_hive_collection.dart';
import '../../domain/entities/user_entity/user_entity.dart';

class UserCollectionImpl implements AppHiveCollection {
  UserCollectionImpl() {
    Hive.openBox('user_box');
  }
  @override
  Box get box => Hive.box('user_box');

  @override
  T get<T>(String id) {
    try {
      final data = box.get(id);
      if (data == null) {
        throw CustomException.noRecords();
      }
      return jsonDecode(data);
    } catch (_) {
      rethrow;
    }
  }

  @override
  List<T> getAll<T>() {
    try {
      final data = box.values;
      if (data.isEmpty) {
        return [];
      }
      final users =
          data.map((e) => UserEntity.fromJson(jsonDecode(e))).toList();
      return users.cast<T>();
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future delete(String id) async {
    try {
      await box.delete(id);
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future addUpdate<T>(String id, T item) async {
    try {
      await box.put(id, jsonEncode(item));
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future deleteAll(List<String> keys) async {
    try {
      await box.deleteAll(keys);
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> openBox() async {
    await Hive.openBox('user_box');
  }

  @override
  List<T> getAllPaged<T>(int page, int size) {
    return [].cast<T>();
  }

  @override
  Future deleteAllCache() async {
    await box.clear();
  }
}
