// AI生成 - Hive存储服务
import 'package:hive_flutter/hive_flutter.dart';
import '../models/travel_plan.dart';
import '../models/attraction.dart';
import '../models/day_plan.dart';
import '../models/user_preferences.dart';

/// Hive本地存储服务
class HiveService {
  static const String _historyBox = 'history_plans';
  static const String _favoritesBox = 'favorite_plans';
  static const String _loginBox = 'login_state';
  static const String _preferencesBox = 'user_preferences';

  /// 初始化Hive
  static Future<void> init() async {
    await Hive.initFlutter();

    // 注册适配器
    Hive.registerAdapter(TravelPlanAdapter());
    Hive.registerAdapter(DayPlanAdapter());
    Hive.registerAdapter(AttractionAdapter());
    Hive.registerAdapter(UserPreferencesAdapter());

    // 打开Box
    await Hive.openBox<TravelPlan>(_historyBox);
    await Hive.openBox<TravelPlan>(_favoritesBox);
    await Hive.openBox(_loginBox);
    await Hive.openBox<UserPreferences>(_preferencesBox);
  }

  /// 获取历史行程
  static List<TravelPlan> getHistoryPlans() {
    final box = Hive.box<TravelPlan>(_historyBox);
    return box.values.toList()
      ..sort((a, b) => b.createTime.compareTo(a.createTime));
  }

  /// 保存历史行程
  static Future<void> saveHistoryPlan(TravelPlan plan) async {
    final box = Hive.box<TravelPlan>(_historyBox);
    await box.put(plan.id, plan);
  }

  /// 获取收藏列表
  static List<TravelPlan> getFavorites() {
    final box = Hive.box<TravelPlan>(_favoritesBox);
    return box.values.toList();
  }

  /// 切换收藏状态
  static Future<void> toggleFavorite(TravelPlan plan) async {
    final box = Hive.box<TravelPlan>(_favoritesBox);
    if (box.containsKey(plan.id)) {
      await box.delete(plan.id);
    } else {
      await box.put(plan.id, plan);
    }
  }

  /// 检查是否已收藏
  static bool isFavorite(String planId) {
    final box = Hive.box<TravelPlan>(_favoritesBox);
    return box.containsKey(planId);
  }

  /// 保存登录状态
  static Future<void> saveLoginState(Map<String, dynamic> user) async {
    final box = Hive.box(_loginBox);
    await box.put('user', user);
  }

  /// 获取登录状态
  static Map<String, dynamic>? getLoginState() {
    final box = Hive.box(_loginBox);
    final user = box.get('user');
    if (user != null) {
      return Map<String, dynamic>.from(user);
    }
    return null;
  }

  /// 清除登录状态
  static Future<void> clearLoginState() async {
    final box = Hive.box(_loginBox);
    await box.delete('user');
  }

  /// 获取用户偏好设置
  static Future<UserPreferences?> getUserPreferences() async {
    final box = Hive.box<UserPreferences>(_preferencesBox);
    return box.get('preferences');
  }

  /// 保存用户偏好设置
  static Future<void> saveUserPreferences(UserPreferences preferences) async {
    final box = Hive.box<UserPreferences>(_preferencesBox);
    await box.put('preferences', preferences);
  }

  /// 获取历史行程数量
  static int getHistoryCount() {
    final box = Hive.box<TravelPlan>(_historyBox);
    return box.length;
  }

  /// 获取收藏数量
  static int getFavoritesCount() {
    final box = Hive.box<TravelPlan>(_favoritesBox);
    return box.length;
  }
}
