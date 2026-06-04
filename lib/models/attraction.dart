// AI生成 - 数据模型
import 'package:hive/hive.dart';

part 'attraction.g.dart';

/// 景点模型
@HiveType(typeId: 1)
class Attraction extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String image;

  @HiveField(3)
  String description;

  @HiveField(4)
  String openTime;

  @HiveField(5)
  String cost;

  @HiveField(6)
  String duration;

  @HiveField(7)
  double rating;

  Attraction({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.openTime,
    required this.cost,
    required this.duration,
    required this.rating,
  });
}
