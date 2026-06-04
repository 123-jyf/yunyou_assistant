// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_plan.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DayPlanAdapter extends TypeAdapter<DayPlan> {
  @override
  final int typeId = 2;

  @override
  DayPlan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DayPlan(
      day: fields[0] as int,
      attractions: (fields[1] as List).cast<Attraction>(),
    );
  }

  @override
  void write(BinaryWriter writer, DayPlan obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.day)
      ..writeByte(1)
      ..write(obj.attractions);
  }
}
