import 'package:flutter/material.dart';

import '../handlers/current_week_handler.dart';

final List<String> days = ["Mon", "Tue", "Wed", "Thu", "Fri"];
final nonHighlightedDecoration = BoxDecoration(
  border: Border.all(width: 3, style: BorderStyle.none),
);
final highlightedDecoration = BoxDecoration(
  border: Border.all(
    width: 3,
    color: Colors.black,
  ),
);

class DayDisplay extends StatefulWidget {
  final int dayNum;

  final int weekNum;

  final Map timetable;

  const DayDisplay({
    super.key,
    required this.dayNum,
    required this.weekNum,
    required this.timetable,
  });

  @override
  State<DayDisplay> createState() => _DayDisplayState();
}

class _DayDisplayState extends State<DayDisplay> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: widget.dayNum == (DateTime.now().weekday - 1)
          ? widget.weekNum == CurrentWeekHandler.currentWeek + 1
              ? highlightedDecoration
              : nonHighlightedDecoration
          : nonHighlightedDecoration,
      // padding: const EdgeInsets.all(3.0),
      child: Column(
        // Periods
        children: [
          for (int periodNum = 1; periodNum < 7; periodNum++)
            Column(
              children: [
                Container(
                  margin: periodNum % 2 != 0
                      ? const EdgeInsets.only(
                          top: 3,
                        )
                      : null,
                  color: widget.timetable[
                                  '${widget.weekNum}${days[widget.dayNum]}:$periodNum']
                              ['TeacherCode'] ==
                          ""
                      ? Colors.grey
                      : Color(
                          int.parse(
                            "${widget.timetable['${widget.weekNum}${days[widget.dayNum]}:$periodNum']['Colour']}"
                                .replaceAll("#", "0xff"),
                          ),
                        ),
                  width: (MediaQuery.of(context).size.width / 5) - 8,
                  height: (MediaQuery.of(context).size.height / 7) - 12,
                  child: Column(
                    children: [
                      Text(
                        "${widget.timetable['${widget.weekNum}${days[widget.dayNum]}:$periodNum']['Subject']}",
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
