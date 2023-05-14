import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:ssa/constants.dart';
import 'package:ssa/contract/sadhana.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ssa/sadhana_form.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ViewSadhana extends StatefulWidget {
  const ViewSadhana({Key? key}) : super(key: key);

  @override
  State<ViewSadhana> createState() => _ViewSadhanaState();
}

class _ViewSadhanaState extends State<ViewSadhana> {
  Box<Sadhana> savedSadhanaBox = Hive.box<Sadhana>(HIVE_BOX_SADHANA_RECORD);

  _getApplicableSadhanaRecord(Box savedSadhanaBox) {
    List<Sadhana> scList = [];
    for (int i = 0; i < savedSadhanaBox.length; ++i) {
      Sadhana si = savedSadhanaBox.getAt(i);
      if (endDate == null && startDate!.compareTo(si.sadhanaForDate) == 0) {
        scList.add(si);
      } else if (endDate != null && startDate!.compareTo(si.sadhanaForDate) <= 0 && si.sadhanaForDate.compareTo(endDate!) <= 0) {
        scList.add(si);
      }
    }
    scList.sort((a, b) => a.sadhanaForDate.compareTo(b.sadhanaForDate));
    return scList;
  }

  List<SadhanaCard> _getSadhanaCardList(Box savedSadhanaBox) {
    return _getApplicableSadhanaRecord(savedSadhanaBox).map<SadhanaCard>((s) => SadhanaCard(s)).toList();
  }

  DateTime? startDate = DateTime.now().subtract(const Duration(days: 6));
  DateTime? endDate = DateTime.now().add(const Duration(days: 0));
  String _range =
      '${DATE_FORMAT.format(DateTime.now().subtract(const Duration(days: 4)))} - ${DATE_FORMAT.format(DateTime.now().add(const Duration(days: 3)))}';

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      startDate = args.value.startDate;
      if (args.value.endDate != null) {
        endDate = args.value.endDate;
      } else {
        endDate = args.value.startDate;
      }
      _range = '${DATE_FORMAT.format(args.value.startDate)} - ${DATE_FORMAT.format(args.value.endDate ?? args.value.startDate)}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          children: [
            Column(
              children: [
                SfDateRangePicker(
                  onSelectionChanged: _onSelectionChanged,
                  selectionMode: DateRangePickerSelectionMode.range,
                  initialSelectedRange: PickerDateRange(startDate, endDate),
                ),
                Text(_range),
                const SizedBox(
                  height: 20,
                ),
                ValueListenableBuilder(
                  valueListenable: savedSadhanaBox.listenable(),
                  builder: (context, Box<Sadhana> box, widget) {
                    if (savedSadhanaBox.length == 0) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24.0),
                          child: Text('No sadhana records found.'),
                        ),
                      );
                    }
                    return Column(
                      children: _getSadhanaCardList(savedSadhanaBox),
                    );
                  },
                ),
              ],
            )
          ],
        ),
        Positioned(
            bottom: 10,
            right: 10,
            child: Container(
              decoration: const BoxDecoration(color: Colors.lightBlueAccent, shape: BoxShape.circle),
              child: IconButton(
                onPressed: () {
                  String title = '${DAY_DATE_FORMAT.format(startDate!)} - ${DAY_DATE_FORMAT.format(endDate!)}\n\n';
                  String sleepTime = 'Last Night Sleep Time:\n';
                  String wakeUpTime = 'Wake Up Time:\n';
                  String sixteenRoundsCompletedAt = '16 rounds completed at:\n';
                  String totalRounds = 'Total Rounds:\n';
                  String hearing = 'Hearing (minutes):\n';
                  String reading = 'Reading (minutes):\n';

                  List<Sadhana> sadhanaList = _getApplicableSadhanaRecord(savedSadhanaBox);

                  for (Sadhana sadhana in sadhanaList) {
                    sleepTime += '${TIME_FORMAT.format(sadhana.lastNightSleepTime)} • ';
                    wakeUpTime += '${TIME_FORMAT.format(sadhana.todaysWakeUpTime)} • ';
                    sixteenRoundsCompletedAt += '${TIME_FORMAT.format(sadhana.sixteenRoundsCompletedTime)} • ';
                    totalRounds += '${sadhana.totalRoundsChanted} • ';
                    hearing += '${sadhana.hearingTimeMins} • ';
                    reading += '${sadhana.readingTimeMins} • ';
                  }

                  String finalMsg = title +
                      sleepTime.substring(0, sleepTime.length - 2) +
                      '\n\n' +
                      wakeUpTime.substring(0, wakeUpTime.length - 2) +
                      '\n\n' +
                      sixteenRoundsCompletedAt.substring(0, sixteenRoundsCompletedAt.length - 2) +
                      '\n\n' +
                      totalRounds.substring(0, totalRounds.length - 2) +
                      '\n\n' +
                      hearing.substring(0, hearing.length - 2) +
                      '\n\n' +
                      reading.substring(0, reading.length - 2);

                  Clipboard.setData(ClipboardData(text: finalMsg));
                  Fluttertoast.showToast(
                    msg: 'Copied!',
                    backgroundColor: Colors.grey,
                  );
                },
                icon: Icon(Icons.copy),
              ),
            )),
      ],
    );
  }
}

class SadhanaCard extends StatelessWidget {
  Box hivePersonalDetailsBox = Hive.box(HIVE_BOX_PERSONAL_DETAILS);
  Box hiveSadhanaBox = Hive.box<Sadhana>(HIVE_BOX_SADHANA_RECORD);

  Sadhana sadhana;

  SadhanaCard(this.sadhana, {super.key});

  @override
  Widget build(BuildContext context) {
    String sadhanaTxtMsg;
    return Container(
      width: MediaQuery.of(context).size.width * 0.975,
      child: GestureDetector(
        onLongPress: () {
          String sadhanaTxtMsg = "Hare Krishna. Dandavat Pranam. All glories to Srila Prabhupada!\n\n" +
              "My Sadhana offering for the pleasure of Guru & Gauranga on ${DATE_FORMAT.format(sadhana.sadhanaForDate)} is as follows:\n\n" +
              " Last Night Sleep Time: ${DATE_TIME_FORMAT.format(sadhana.lastNightSleepTime)}\n" +
              " Todays Wake Up Time: ${DATE_TIME_FORMAT.format(sadhana.todaysWakeUpTime)}\n\n" +
              " Total Rounds Chanted: ${sadhana.totalRoundsChanted}\n\n" +
              " 16 rounds completed @: ${DATE_TIME_FORMAT.format(sadhana.sixteenRoundsCompletedTime)} \n\n" +
              " Hearing Time: ${sadhana.hearingTimeMins} mins\n" +
              " Topic: ${sadhana.hearingTopic} \n\n" +
              " Reading Time: ${sadhana.readingTimeMins} mins\n" +
              " Topic: ${sadhana.readingTopic} \n\n" +
              "Your servant, \n" +
              "${hivePersonalDetailsBox.get('name')}";
          Clipboard.setData(ClipboardData(text: sadhanaTxtMsg));
          Fluttertoast.showToast(
            msg: 'Copied!',
            backgroundColor: Colors.grey,
          );
        },
        child: Card(
          shadowColor: Colors.grey,
          child: Row(
            children: [
              Expanded(
                flex: 9,
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 8, top: 12, bottom: 12),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Text(sadhana.toString()),
                  ),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push<void>(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) => Scaffold(
                                  appBar: AppBar(
                                    title: Text('SSA'),
                                  ),
                                  body: SadhanaForm.fromSadhana(sadhana)),
                            ),
                          );
                        },
                        child: Icon(Icons.edit),
                      ),
                      InkWell(
                        onTap: () {
                          hiveSadhanaBox.delete(DATE_FORMAT.format(sadhana.sadhanaForDate));
                        },
                        child: Icon(Icons.delete_forever_outlined),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
