import 'dart:math';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:ssa/constants.dart';
import 'package:ssa/contract/sadhana.dart';


class SadhanaForm extends StatefulWidget {
 DateTime? today;


 DateTime? sadhanaForDate;
 DateTime? lastNightSleepTime;
 DateTime? todaysWakeUpTime;
 DateTime? sixteenRoundsCompletedTime;
 int totalRoundsChanted = 16;
 int hearingTimeMins = 0;
 int readingTimeMins = 0;
 String hearingTopic = "";
 String readingTopic = "";
 bool editMode = false;


 SadhanaForm(this.today) {
   today = DateTime(today!.year, today!.month, today!.day);
   editMode = false;
   sadhanaForDate = today;
   lastNightSleepTime = today;
   todaysWakeUpTime = today;
   sixteenRoundsCompletedTime = today;
 }


 SadhanaForm.fromSadhana(Sadhana sadhana) {
   editMode = true;
   sadhanaForDate = sadhana.sadhanaForDate;
   lastNightSleepTime = sadhana.lastNightSleepTime;
   todaysWakeUpTime = sadhana.todaysWakeUpTime;
   sixteenRoundsCompletedTime = sadhana.sixteenRoundsCompletedTime;
   totalRoundsChanted = sadhana.totalRoundsChanted;
   hearingTimeMins = sadhana.hearingTimeMins;
   readingTimeMins = sadhana.readingTimeMins;
   hearingTopic = sadhana.hearingTopic;
   readingTopic = sadhana.readingTopic;
 }


 @override
 State<SadhanaForm> createState() => _SadhanaFormState();
}


class _SadhanaFormState extends State<SadhanaForm> {
 DateTime time = DateTime(2016, 5, 10, 22, 35);
 DateTime dateTime = DateTime(2016, 8, 3, 17, 45);


 TextEditingController? _totalRoundsController;
 TextEditingController? _hearingTimeController;
 TextEditingController? _readingTimeController;
 TextEditingController? _hearingTopicController;
 TextEditingController? _readingTopicController;
 Box<Sadhana> favoriteAudiosBox = Hive.box<Sadhana>(HIVE_BOX_SADHANA_RECORD);


 DateTime? minDate;
 DateTime? maxDate;


 DateTime? minDateSleepWakeInput;
 DateTime? maxDateSleepWakeInput;
 DateTime? selectedDateMinus1, selectedDatePlus1;


 _updateSelectedMinMaxDates() {
   if (widget.editMode) {
     selectedDateMinus1 = widget.sadhanaForDate!.subtract(const Duration(days: 1));
     selectedDatePlus1 = widget.sadhanaForDate!.add(const Duration(days: 2));
   } else {
     selectedDateMinus1 = widget.today!.subtract(const Duration(days: 1));
     selectedDatePlus1 = widget.today!.add(const Duration(days: 2));
   }
 }


 @override
 void initState() {
   super.initState();
   _totalRoundsController = TextEditingController(text: "${widget.totalRoundsChanted}");
   _hearingTimeController = TextEditingController(text: "${widget.hearingTimeMins}");
   _readingTimeController = TextEditingController(text: "${widget.readingTimeMins}");
   _hearingTopicController = TextEditingController(text: widget.hearingTopic);
   _readingTopicController = TextEditingController(text: widget.readingTopic);


   if (widget.editMode) {
     minDate = widget.sadhanaForDate!;
     maxDate = widget.sadhanaForDate!;
   } else {
     minDate = widget.today!.subtract(const Duration(days: 15));
     maxDate = widget.today!.add(const Duration(days: 2));
   }
   _updateSelectedMinMaxDates();
 }


 @override
 void dispose() {
   _totalRoundsController!.dispose();
   super.dispose();
 }


 void _showDialog(Widget child) {
   showCupertinoModalPopup<void>(
     context: context,
     builder: (BuildContext context) => Container(
       height: 216,
       padding: const EdgeInsets.only(top: 6.0),
       // The Bottom margin is provided to align the popup above the system
       // navigation bar.
       margin: EdgeInsets.only(
         bottom: MediaQuery.of(context).viewInsets.bottom,
       ),
       // Provide a background color for the popup.
       color: CupertinoColors.systemBackground.resolveFrom(context),
       // Use a SafeArea widget to avoid system overlaps.
       child: SafeArea(
         top: false,
         child: child,
       ),
     ),
   );
 }


 @override
 Widget build(BuildContext context) {
   String sadhanaForDateText = DATE_FORMAT.format(widget.sadhanaForDate!);
   return SingleChildScrollView(
     child: Padding(
       padding: const EdgeInsets.all(12.0),
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           Padding(
             padding: EdgeInsets.all(3),
             child: widget.editMode ? const Text('Editing Sadhana for date') : const Text('Saving Sadhana for date'),
           ),
           widget.editMode
               ? Text(sadhanaForDateText,
                   style: const TextStyle(
                     fontSize: 22.0,
                   ))
               : CupertinoButton(
                   onPressed: () => _showDialog(
                         CupertinoDatePicker(
                           initialDateTime: widget.sadhanaForDate,
                           mode: CupertinoDatePickerMode.date,
                           use24hFormat: true,
                           minimumDate: minDate,
                           maximumDate: maxDate,
                           onDateTimeChanged: (DateTime newDate) {
                             setState(() {
                               widget.sadhanaForDate = newDate;
                               selectedDateMinus1 = newDate.subtract(const Duration(days: 1));
                               selectedDatePlus1 = newDate.add(const Duration(days: 2));
                             });
                           },
                         ),
                       ),
                   child: Text(
                     sadhanaForDateText,
                     style: const TextStyle(
                       fontSize: 22.0,
                     ),
                   )),
           const SizedBox(
             height: 27.5,
           ),
           const Text('Last Night Sleep Time'),
           CupertinoButton(
             // Display a CupertinoDatePicker in dateTime picker mode.
             onPressed: () => _showDialog(
               CupertinoDatePicker(
                 initialDateTime: widget.editMode ? widget.lastNightSleepTime : widget.sadhanaForDate,
                 minimumDate: selectedDateMinus1,
                 maximumDate: selectedDatePlus1,
                 use24hFormat: true,
                 // This is called when the user changes the dateTime.
                 onDateTimeChanged: (DateTime newDateTime) {
                   setState(() => widget.lastNightSleepTime = newDateTime);
                 },
               ),
             ),
             // In this example, the time value is formatted manually. You
             // can use the intl package to format the value based on the
             // user's locale settings.
             child: Text(
               DATE_TIME_FORMAT.format(widget.lastNightSleepTime!),
               style: const TextStyle(
                 fontSize: 22.0,
               ),
             ),
           ),
           const SizedBox(
             height: 27.5,
           ),
           const Text('Today\'s Wake Up Time'),
           CupertinoButton(
             // Display a CupertinoDatePicker in dateTime picker mode.
             onPressed: () => _showDialog(
               CupertinoDatePicker(
                 initialDateTime: widget.editMode ? widget.todaysWakeUpTime : widget.sadhanaForDate,
                 minimumDate: selectedDateMinus1,
                 maximumDate: selectedDatePlus1,
                 use24hFormat: true,
                 // This is called when the user changes the dateTime.
                 onDateTimeChanged: (DateTime newDateTime) {
                   setState(() => widget.todaysWakeUpTime = newDateTime);
                 },
               ),
             ),
             child: Text(
               DATE_TIME_FORMAT.format(widget.todaysWakeUpTime!),
               style: const TextStyle(
                 fontSize: 22.0,
               ),
             ),
           ),
           const SizedBox(
             height: 27.5,
           ),
           Container(
             width: MediaQuery.of(context).size.width * 0.8,
             child: const Text(
               '16 rounds completed Time (if you chant < 16 rounds, fill in the time at which you completed the maximum number of rounds for the day)',
               style: TextStyle(fontSize: 10),
             ),
           ),
           CupertinoButton(
             // Display a CupertinoDatePicker in dateTime picker mode.
             onPressed: () => _showDialog(
               CupertinoDatePicker(
                 initialDateTime: widget.editMode ? widget.sixteenRoundsCompletedTime : widget.sadhanaForDate,
                 minimumDate: selectedDateMinus1,
                 maximumDate: selectedDatePlus1,
                 use24hFormat: true,
                 // This is called when the user changes the dateTime.
                 onDateTimeChanged: (DateTime newDateTime) {
                   setState(() => widget.sixteenRoundsCompletedTime = newDateTime);
                 },
               ),
             ),
             // In this example, the time value is formatted manually. You
             // can use the intl package to format the value based on the
             // user's locale settings.
             child: Text(
               DATE_TIME_FORMAT.format(widget.sixteenRoundsCompletedTime!),
               style: const TextStyle(
                 fontSize: 22.0,
               ),
             ),
           ),
           const SizedBox(
             height: 27.5,
           ),
           TextField(
             controller: _totalRoundsController,
             decoration: const InputDecoration(labelText: "Enter total of rounds chanted"),
             keyboardType: TextInputType.number,
             inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly], // Only numbers can be entered
           ),
           const SizedBox(
             height: 27.5,
           ),
           TextField(
             decoration: const InputDecoration(labelText: "Total hearing time in minutes"),
             controller: _hearingTimeController,
             keyboardType: TextInputType.number,
             inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly], // Only numbers can be entered
           ),
           TextField(
             decoration: const InputDecoration(labelText: "Hearing topic"),
             controller: _hearingTopicController,
             keyboardType: TextInputType.text,
           ),
           const SizedBox(
             height: 27.5,
           ),
           TextField(
             decoration: const InputDecoration(labelText: "Total reading time in minutes"),
             controller: _readingTimeController,
             keyboardType: TextInputType.number,
             inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly], // Only numbers can be entered
           ),
           TextField(
             decoration: const InputDecoration(labelText: "Reading topic"),
             controller: _readingTopicController,
             keyboardType: TextInputType.text,
           ),
           SizedBox(
             height: 27.5,
           ),
           TextButton(
             style: TextButton.styleFrom(
               foregroundColor: Colors.white,
               backgroundColor: Colors.lightBlueAccent,
               padding: const EdgeInsets.all(16.0),
               textStyle: const TextStyle(fontSize: 20),
             ),
             onPressed: () {
               // hivePersonalDetailsBox.put('name', myController.text);
               Sadhana s = Sadhana(
                   sadhanaForDate: widget.sadhanaForDate!,
                   lastNightSleepTime: widget.lastNightSleepTime!,
                   todaysWakeUpTime: widget.todaysWakeUpTime!,
                   sixteenRoundsCompletedTime: widget.sixteenRoundsCompletedTime!,
                   totalRoundsChanted: int.parse(_totalRoundsController!.text),
                   hearingTimeMins: int.parse(_hearingTimeController!.text),
                   hearingTopic: _hearingTopicController!.text,
                   readingTimeMins: int.parse(_readingTimeController!.text),
                   readingTopic: _readingTopicController!.text);
               String key = DATE_FORMAT.format(widget.sadhanaForDate!);
               favoriteAudiosBox.put(key, s);
               Fluttertoast.showToast(msg: 'Saved!');
             },
             child: const Text('Save'),
           ),
         ],
       ),
     ),
   );
 }
}

