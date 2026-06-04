// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_preferences.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserPreferencesAdapter extends TypeAdapter<UserPreferences> {
  @override
  final int typeId = 4;

  @override
  UserPreferences read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserPreferences(
      defaultDays: fields[0] as int,
      defaultBudget: fields[1] as String,
      interests: (fields[2] as List).cast<String>(),
      defaultPeople: fields[3] as String,
      darkMode: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, UserPreferences obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.defaultDays)
      ..writeByte(1)
      ..write(obj.defaultBudget)
      ..writeByte(2)
      ..write(obj.interests)
      ..writeByte(3)
      ..write(obj.defaultPeople)
      ..writeByte(4)
      ..write(obj.darkMode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserPreferencesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
