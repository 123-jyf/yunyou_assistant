// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attraction.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AttractionAdapter extends TypeAdapter<Attraction> {
  @override
  final int typeId = 1;

  @override
  Attraction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Attraction(
      id: fields[0] as String,
      name: fields[1] as String,
      image: fields[2] as String,
      description: fields[3] as String,
      openTime: fields[4] as String,
      cost: fields[5] as String,
      duration: fields[6] as String,
      rating: fields[7] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Attraction obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.image)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.openTime)
      ..writeByte(5)
      ..write(obj.cost)
      ..writeByte(6)
      ..write(obj.duration)
      ..writeByte(7)
      ..write(obj.rating);
  }
}
