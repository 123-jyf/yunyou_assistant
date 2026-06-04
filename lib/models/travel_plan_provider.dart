// AI生成 - 状态管理
import 'package:flutter/foundation.dart';
import '../models/travel_plan.dart';

/// 行程数据Provider
class TravelPlanProvider with ChangeNotifier {
  List<TravelPlan> _historyPlans = [];
  List<TravelPlan> _favorites = [];
  TravelPlan? _currentPlan;

  List<TravelPlan> get historyPlans => List.unmodifiable(_historyPlans);
  List<TravelPlan> get favorites => List.unmodifiable(_favorites);
  TravelPlan? get currentPlan => _currentPlan;

  /// 设置当前行程
  void setCurrentPlan(TravelPlan plan) {
    _currentPlan = plan;
    notifyListeners();
  }

  /// 添加到历史记录
  void addToHistory(TravelPlan plan) {
    if (!_historyPlans.any((p) => p.id == plan.id)) {
      _historyPlans.insert(0, plan);
      _historyPlans.sort((a, b) => b.createTime.compareTo(a.createTime));
      notifyListeners();
    }
  }

  /// 添加到历史记录（别名）
  void addHistory(TravelPlan plan) {
    addToHistory(plan);
  }

  /// 切换收藏状态
  void toggleFavorite(TravelPlan plan) {
    final index = _favorites.indexWhere((p) => p.id == plan.id);
    if (index >= 0) {
      _favorites.removeAt(index);
    } else {
      _favorites.add(plan);
    }
    notifyListeners();
  }

  /// 检查是否已收藏
  bool isFavorite(String planId) {
    return _favorites.any((p) => p.id == planId);
  }

  /// 初始化数据
  void initialize({
    required List<TravelPlan> history,
    required List<TravelPlan> favs,
  }) {
    _historyPlans = history;
    _favorites = favs;
    notifyListeners();
  }
}
