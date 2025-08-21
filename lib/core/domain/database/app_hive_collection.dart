import 'package:hive/hive.dart';

abstract class AppHiveCollection {
  Box get box;
  void openBox();
  T get<T>(String id);
  List<T> getAll<T>();
  Future delete(String id);
  Future deleteAll(List<String> keys);
  Future deleteAllCache();
  Future addUpdate<T>(String id, T item);
  List<T> getAllPaged<T>(int page, int size);
}
