import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageUtils {
  // Singleton instance
  static final LocalStorageUtils instance = LocalStorageUtils._internal();
  factory LocalStorageUtils() => instance;
  LocalStorageUtils._internal();

  /// Write value (Handles String, int, bool, double)
  Future<void> write<T>(String key, T value) async {
    log('Writing data: $key = $value');
    final storage = await SharedPreferences.getInstance();

    if (value is String) {
      await storage.setString(key, value);
    } else if (value is int) {
      await storage.setInt(key, value);
    } else if (value is bool) {
      await storage.setBool(key, value);
    } else if (value is double) {
      await storage.setDouble(key, value);
    } else {
      throw Exception("Unsupported data type");
    }
  }

  /// Read value (Generic type handling)
  Future<T?> read<T>(String key) async {
    final storage = await SharedPreferences.getInstance();
    dynamic value = storage.get(key);
    log('Reading data: $key = $value');
    return value as T?;
  }

  /// Delete value
  Future<void> delete(String key) async {
    log('Deleting data: $key');
    final storage = await SharedPreferences.getInstance();
    await storage.remove(key);
  }

  /// Clear all session data
  Future<void> clear() async {
    log('Clearing all session data');
    final storage = await SharedPreferences.getInstance();
    await storage.clear();
  }
}
