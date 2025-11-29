import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 依存性注入モジュール
@module
abstract class InjectionModule {
  /// SharedPreferencesインスタンスを提供
  @preResolve
  @lazySingleton
  Future<SharedPreferences> get sharedPreferences =>
      SharedPreferences.getInstance();
}
