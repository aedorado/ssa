// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sadhana.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SadhanaAdapter extends TypeAdapter<Sadhana> {
  @override
  final int typeId = 0;

  @override
  Sadhana read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Sadhana(
      sadhanaForDate: fields[0] as DateTime,
      lastNightSleepTime: fields[1] as DateTime,
      todaysWakeUpTime: fields[2] as DateTime,
      sixteenRoundsCompletedTime: fields[3] as DateTime,
      totalRoundsChanted: fields[4] as int,
      hearingTimeMins: fields[5] as int,
      hearingTopic: fields[6] as String,
      readingTimeMins: fields[7] as int,
      readingTopic: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Sadhana obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.sadhanaForDate)
      ..writeByte(1)
      ..write(obj.lastNightSleepTime)
      ..writeByte(2)
      ..write(obj.todaysWakeUpTime)
      ..writeByte(3)
      ..write(obj.sixteenRoundsCompletedTime)
      ..writeByte(4)
      ..write(obj.totalRoundsChanted)
      ..writeByte(5)
      ..write(obj.hearingTimeMins)
      ..writeByte(6)
      ..write(obj.hearingTopic)
      ..writeByte(7)
      ..write(obj.readingTimeMins)
      ..writeByte(8)
      ..write(obj.readingTopic);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SadhanaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
