import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ssa/constants.dart';
import 'package:ssa/contract/sadhana.dart';

class Charts extends StatefulWidget {
  const Charts({Key? key}) : super(key: key);

  @override
  State<Charts> createState() => _ChartsState();
}

class _ChartsState extends State<Charts> {
  Box<Sadhana> savedSadhanaBox = Hive.box<Sadhana>(HIVE_BOX_SADHANA_RECORD);

  List<Sadhana> _getMonthlySadhana(month, year) {
    DateTime startDate = DateTime(year, month);
    debugPrint(startDate.toString());
    DateTime endDate = DateTime(year, ((month + 1) % 13) + 1, 0);
    List<Sadhana> scList = [];
    for (int i = 0; i < savedSadhanaBox.length; ++i) {
      Sadhana? si = savedSadhanaBox.getAt(i);
      if (startDate.compareTo(si!.sadhanaForDate) <= 0 && si!.sadhanaForDate.compareTo(endDate) <= 0) {
        scList.add(si);
      }
    }
    scList.sort((a, b) => a!.sadhanaForDate.compareTo(b!.sadhanaForDate));
    return scList;
  }

  @override
  Widget build(BuildContext context) {
    List<Sadhana> scList = _getMonthlySadhana(5, 2023);
    final List<FlSpot> chartData = List.generate(scList.length, (index) {
      Sadhana s = scList.elementAt(index);
      debugPrint('${s.sadhanaForDate.day}');
      return FlSpot(s.sadhanaForDate.day * 1.0, s.totalRoundsChanted * 1.0);
    });
    return AspectRatio(
      aspectRatio: 2,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: chartData,
              isCurved: false,
              // dotData: FlDotData(
              //   show: false,
              // ),
            ),
          ],
        ),
      ),
    );
  }
}
