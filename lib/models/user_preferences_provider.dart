// AI生成 - 用户偏好状态管理
import 'package:flutter/material.dart';
import 'user_preferences.dart';
import '../services/hive_service.dart';

/// 用户偏好状态管理Provider
class UserPreferencesProvider extends ChangeNotifier {
  UserPreferences _preferences = UserPreferences.defaultPreferences();

  UserPreferences get preferences => _preferences;

  /// 初始化加载用户偏好
  Future<void> loadPreferences() async {
    final prefs = await HiveService.getUserPreferences();
    if (prefs != null) {
      _preferences = prefs;
      notifyListeners();
    }
  }

  /// 更新用户偏好
  void setPreferences(UserPreferences preferences) {
    _preferences = preferences;
    notifyListeners();
  }

  /// 更新单个偏好值
  void updatePreference({
    int? defaultDays,
    String? defaultBudget,
    List<String>? interests,
    String? defaultPeople,
    bool? darkMode,
  }) {
    if (defaultDays != null) _preferences.defaultDays = defaultDays;
    if (defaultBudget != null) _preferences.defaultBudget = defaultBudget;
    if (interests != null) _preferences.interests = interests;
    if (defaultPeople != null) _preferences.defaultPeople = defaultPeople;
    if (darkMode != null) _preferences.darkMode = darkMode;
    notifyListeners();
  }
}
