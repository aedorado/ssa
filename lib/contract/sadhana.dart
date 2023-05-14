import 'package:hive/hive.dart';
import 'package:ssa/constants.dart';

part 'sadhana.g.dart';



@HiveType(typeId: 0)
class Sadhana {
  @HiveField(0)
  late DateTime sadhanaForDate;

  @HiveField(1)
  late DateTime lastNightSleepTime;

  @HiveField(2)
  late DateTime todaysWakeUpTime;

  @HiveField(3)
  late DateTime sixteenRoundsCompletedTime;

  @HiveField(4)
  late int totalRoundsChanted;

  @HiveField(5)
  late int hearingTimeMins;

  @HiveField(6)
  late String hearingTopic;

  @HiveField(7)
  late int readingTimeMins;

  @HiveField(8)
  late String readingTopic;

  Sadhana(
      {required this.sadhanaForDate,
      required this.lastNightSleepTime,
      required this.todaysWakeUpTime,
      required this.sixteenRoundsCompletedTime,
      required this.totalRoundsChanted,
      required this.hearingTimeMins,
      required this.hearingTopic,
      required this.readingTimeMins,
      required this.readingTopic});

  // Audio.fromJson(Map<String, dynamic> json) {
  //   id = json['id'] ?? json['id'];
  //   name = json['name'] ?? json['name'];
  //   url = json['url'] ?? json['url'];
  //   thumbnailUrl = json['thumbnailUrl'] ?? json['thumbnailUrl'];
  //   namePlainText = json['namePlainText'] ?? '';
  // }
  //
  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['id'] = this.id;
  //   data['name'] = this.name;
  //   data['url'] = this.url;
  //   data['thumbnailUrl'] = this.thumbnailUrl;
  //   data['namePlainText'] = this.namePlainText;
  //   return data;
  // }

  @override
  String toString() {
    return "Date: ${DATE_FORMAT.format(sadhanaForDate)}\nLastNightSleepTime: ${DATE_TIME_FORMAT.format(lastNightSleepTime)}\nTodaysWakeUpTime: ${DATE_TIME_FORMAT.format(todaysWakeUpTime)}\n16RoundsCompleted@: ${DATE_TIME_FORMAT.format(sixteenRoundsCompletedTime)}\nTotalRoundsChanted: $totalRoundsChanted\nHearingTimeMins: $hearingTimeMins mins\nHearingTopic: $hearingTopic\nReadingTimeMins: $readingTimeMins mins\nReadingTopic: $readingTopic";
  }

}
