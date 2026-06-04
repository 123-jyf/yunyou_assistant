// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'travel_plan.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TravelPlanAdapter extends TypeAdapter<TravelPlan> {
  @override
  final int typeId = 0;

  @override
  TravelPlan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TravelPlan(
      id: fields[0] as String,
      destination: fields[1] as String,
      days: fields[2] as int,
      budget: fields[3] as String,
      interests: (fields[4] as List).cast<String>(),
      people: fields[5] as String,
      totalBudget: fields[6] as String,
      createTime: fields[7] as DateTime,
      dayPlans: (fields[8] as List).cast<DayPlan>(),
    );
  }

  @override
  void write(BinaryWriter writer, TravelPlan obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.destination)
      ..writeByte(2)
      ..write(obj.days)
      ..writeByte(3)
      ..write(obj.budget)
      ..writeByte(4)
      ..write(obj.interests)
      ..writeByte(5)
      ..write(obj.people)
      ..writeByte(6)
      ..write(obj.totalBudget)
      ..writeByte(7)
      ..write(obj.createTime)
      ..writeByte(8)
      ..write(obj.dayPlans);
  }
}
