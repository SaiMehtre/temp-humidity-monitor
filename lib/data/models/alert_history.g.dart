// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alert_history.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AlertHistoryAdapter extends TypeAdapter<AlertHistory> {
  @override
  final int typeId = 0;

  @override
  AlertHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AlertHistory(
      fields[0] as String,
      fields[1] as double,
      fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, AlertHistory obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.value)
      ..writeByte(2)
      ..write(obj.time);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlertHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
