// author: Lukas Horst

import 'package:hive_flutter/hive_flutter.dart';

// Class to handle the hive database for local storage
class HiveDatabase {

  static late Box _box;

  static Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox('localeUserSettings');
  }

  static Future<void> insertData(dynamic key, dynamic value) async {
    await _box.put(key, value);
  }

  static Future<void> deleteData(dynamic key) async {
    await _box.delete(key);
  }

  static dynamic getValue(dynamic key) async {
    return await _box.get(key);
  }

}