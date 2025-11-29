import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/errors/exceptions.dart';

/// ローカルストレージデータソース
@lazySingleton
class LocalStorageDataSource {
  final SharedPreferences sharedPreferences;

  LocalStorageDataSource(this.sharedPreferences);

  /// 文字列を保存
  Future<void> saveString(String key, String value) async {
    try {
      await sharedPreferences.setString(key, value);
    } catch (e) {
      throw CacheException('文字列の保存に失敗しました: $e');
    }
  }

  /// 文字列を取得
  String? getString(String key) {
    try {
      return sharedPreferences.getString(key);
    } catch (e) {
      throw CacheException('文字列の取得に失敗しました: $e');
    }
  }

  /// 整数を保存
  Future<void> saveInt(String key, int value) async {
    try {
      await sharedPreferences.setInt(key, value);
    } catch (e) {
      throw CacheException('整数の保存に失敗しました: $e');
    }
  }

  /// 整数を取得
  int? getInt(String key) {
    try {
      return sharedPreferences.getInt(key);
    } catch (e) {
      throw CacheException('整数の取得に失敗しました: $e');
    }
  }

  /// 真偽値を保存
  Future<void> saveBool(String key, bool value) async {
    try {
      await sharedPreferences.setBool(key, value);
    } catch (e) {
      throw CacheException('真偽値の保存に失敗しました: $e');
    }
  }

  /// 真偽値を取得
  bool? getBool(String key) {
    try {
      return sharedPreferences.getBool(key);
    } catch (e) {
      throw CacheException('真偽値の取得に失敗しました: $e');
    }
  }

  /// JSONオブジェクトを保存
  Future<void> saveJson(String key, Map<String, dynamic> json) async {
    try {
      final jsonString = jsonEncode(json);
      await sharedPreferences.setString(key, jsonString);
    } catch (e) {
      throw CacheException('JSONの保存に失敗しました: $e');
    }
  }

  /// JSONオブジェクトを取得
  Map<String, dynamic>? getJson(String key) {
    try {
      final jsonString = sharedPreferences.getString(key);
      if (jsonString == null) return null;
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      throw CacheException('JSONの取得に失敗しました: $e');
    }
  }

  /// 文字列リストを保存
  Future<void> saveStringList(String key, List<String> value) async {
    try {
      await sharedPreferences.setStringList(key, value);
    } catch (e) {
      throw CacheException('文字列リストの保存に失敗しました: $e');
    }
  }

  /// 文字列リストを取得
  List<String>? getStringList(String key) {
    try {
      return sharedPreferences.getStringList(key);
    } catch (e) {
      throw CacheException('文字列リストの取得に失敗しました: $e');
    }
  }

  /// キーを削除
  Future<void> remove(String key) async {
    try {
      await sharedPreferences.remove(key);
    } catch (e) {
      throw CacheException('キーの削除に失敗しました: $e');
    }
  }

  /// すべてのキーをクリア
  Future<void> clear() async {
    try {
      await sharedPreferences.clear();
    } catch (e) {
      throw CacheException('データのクリアに失敗しました: $e');
    }
  }

  /// キーが存在するか確認
  bool containsKey(String key) {
    return sharedPreferences.containsKey(key);
  }
}
