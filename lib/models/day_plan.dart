// AI生成 - 数据模型
import 'package:hive/hive.dart';
import 'attraction.dart';

part 'day_plan.g.dart';

/// 每日行程模型
@HiveType(typeId: 2)
class DayPlan extends HiveObject {
  @HiveField(0)
  int day;

  @HiveField(1)
  List<Attraction> attractions;

  DayPlan({
    required this.day,
    required this.attractions,
  });
}
