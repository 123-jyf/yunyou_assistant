// AI生成 - 用户偏好数据模型
import 'package:hive/hive.dart';

part 'user_preferences.g.dart';

/// 用户偏好设置模型
@HiveType(typeId: 4)
class UserPreferences extends HiveObject {
  @HiveField(0)
  int defaultDays;

  @HiveField(1)
  String defaultBudget;

  @HiveField(2)
  List<String> interests;

  @HiveField(3)
  String defaultPeople;

  @HiveField(4)
  bool darkMode;

  UserPreferences({
    required this.defaultDays,
    required this.defaultBudget,
    required this.interests,
    required this.defaultPeople,
    required this.darkMode,
  });

  /// 默认偏好设置
  factory UserPreferences.defaultPreferences() {
    return UserPreferences(
      defaultDays: 3,
      defaultBudget: '舒适',
      interests: ['自然风光', '美食'],
      defaultPeople: '情侣',
      darkMode: false,
    );
  }

  /// 复制方法
  UserPreferences copyWith({
    int? defaultDays,
    String? defaultBudget,
    List<String>? interests,
    String? defaultPeople,
    bool? darkMode,
  }) {
    return UserPreferences(
      defaultDays: defaultDays ?? this.defaultDays,
      defaultBudget: defaultBudget ?? this.defaultBudget,
      interests: interests ?? List.from(this.interests),
      defaultPeople: defaultPeople ?? this.defaultPeople,
      darkMode: darkMode ?? this.darkMode,
    );
  }
}
