// AI生成 - 数据模型
import 'package:hive/hive.dart';
import 'day_plan.dart';

part 'travel_plan.g.dart';

/// 旅行计划模型
@HiveType(typeId: 0)
class TravelPlan extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String destination;

  @HiveField(2)
  int days;

  @HiveField(3)
  String budget;

  @HiveField(4)
  List<String> interests;

  @HiveField(5)
  String people;

  @HiveField(6)
  String totalBudget;

  @HiveField(7)
  DateTime createTime;

  @HiveField(8)
  List<DayPlan> dayPlans;

  TravelPlan({
    required this.id,
    required this.destination,
    required this.days,
    required this.budget,
    required this.interests,
    required this.people,
    required this.totalBudget,
    required this.createTime,
    required this.dayPlans,
  });
}
