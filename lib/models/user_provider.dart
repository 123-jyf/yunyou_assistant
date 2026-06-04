// AI生成 - 用户登录状态管理
import 'package:flutter/material.dart';
import '../services/hive_service.dart';

/// 用户状态管理Provider
class UserProvider extends ChangeNotifier {
  Map<String, dynamic>? _user;
  bool _isLoggedIn = false;

  Map<String, dynamic>? get user => _user;
  bool get isLoggedIn => _isLoggedIn;

  /// 检查登录状态
  Future<void> checkLoginStatus() async {
    final loginState = await HiveService.getLoginState();
    if (loginState != null) {
      _user = Map<String, dynamic>.from(loginState);
      _isLoggedIn = true;
      notifyListeners();
    }
  }

  /// 设置用户
  void setUser(Map<String, dynamic> user) {
    _user = user;
    _isLoggedIn = true;
    notifyListeners();
  }

  /// 退出登录
  Future<void> logout() async {
    await HiveService.clearLoginState();
    _user = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}
