// lib/utils/local_secure_storage.dart
// Armazenamento seguro
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalSecureStorage {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<void> saveObject(String key, dynamic value) async {
    final jsonString = jsonEncode(
      value is Map<String, dynamic> ? value : (value as dynamic).toJson(),
    );
    await _storage.write(key: key, value: jsonString);
  }

  static Future<T?> readObject<T>(
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final jsonString = await _storage.read(key: key);
    if (jsonString == null) return null;
    final map = jsonDecode(jsonString) as Map<String, dynamic>;
    return fromJson(map);
  }

  static Future<void> saveObjectList<T>(String key, List<T> list) async {
    final jsonList = list.map((e) => (e as dynamic).toJson()).toList();
    final jsonString = jsonEncode(jsonList);
    await _storage.write(key: key, value: jsonString);
  }

  static Future<List<T>> readObjectList<T>(
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final jsonString = await _storage.read(key: key);
    if (jsonString == null) return [];
    final list = jsonDecode(jsonString) as List;
    return list.map((e) => fromJson(e as Map<String, dynamic>)).toList();
  }

  static Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  static Future<void> clear() async {
    await _storage.deleteAll();
  }
}
