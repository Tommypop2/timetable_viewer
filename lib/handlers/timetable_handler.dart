import "package:http/http.dart" as http;
import 'package:timetable_viewer/handlers/current_week_handler.dart';
import 'token_handler.dart';
import "dart:convert";

List<int> getIndexes(String pattern, String obj) {
  List<int> indexes = [];
  int patternLen = pattern.length;
  for (int i = 0; i < obj.length - patternLen + 1; i++) {
    String substring = obj.substring(i, i + patternLen);
    if (substring == pattern) {
      indexes.add(i);
    }
  }
  return indexes;
}

class TimetableHandler {
  static final TimetableHandler _timetableHandler =
      TimetableHandler._timetableHandlerConstructor();
  static Map currentTimetable = {};
  static Future<void> getTimetable() async {
    print(await CurrentWeekHandler.getCurrentWeek());
    final res = await http.get(
        Uri.parse("https://my.hartismere.com/timetables"),
        headers: {'Cookie': 'HFOS_USR=${TokenHandler.loginToken}'});
    String timetableString = res.body;
    int startIndex = getIndexes("[", timetableString)[0];
    List<int> indexesOfClose = getIndexes("]", timetableString);
    int endIndex = indexesOfClose[indexesOfClose.length - 1];
    String substring = "${timetableString.substring(startIndex, endIndex)}]";
    final timetable = json.decode(substring);
    var fixedTimetable = {};
    final periods = timetable[0]["Periods"];
    for (int i = 0; i < periods.length; i++) {
      final element = periods[i];

      fixedTimetable[element["Name"]] = element;
    }
    currentTimetable = fixedTimetable;
  }

  factory TimetableHandler() {
    return _timetableHandler;
  }
  TimetableHandler._timetableHandlerConstructor();
}
