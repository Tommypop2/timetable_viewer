import 'package:flutter/material.dart';
import 'day.dart';

class WeekDisplay extends StatefulWidget {
  final Map timetable;

  final int weekNum;

  const WeekDisplay({
    super.key,
    required this.weekNum,
    required this.timetable,
  });

  @override
  State<WeekDisplay> createState() => _WeekDisplayState();
}

class _WeekDisplayState extends State<WeekDisplay> {
  @override
  Widget build(BuildContext context) {
    return Row(
      // Days
      children: [
        for (int dayNum = 0; dayNum < 5; dayNum++)
          DayDisplay(
            dayNum: dayNum,
            weekNum: widget.weekNum,
            timetable: widget.timetable,
          ),
      ],
    );
  }
}
