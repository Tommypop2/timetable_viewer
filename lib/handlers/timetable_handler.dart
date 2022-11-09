import "package:http/http.dart" as http;
import 'package:shared_preferences/shared_preferences.dart';
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
  static Map? currentTimetable = {};
  static Future<void> getTimetableFromServer() async {
    String timetableString = "";
    try {
      final res = await http.get(
          Uri.parse("https://my.hartismere.com/timetables"),
          headers: {'Cookie': 'HFOS_USR=${TokenHandler.loginToken}'});
      timetableString = res.body;
    } catch (e) {
      currentTimetable = null;
      return;
    }
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

  static Future<void> storeTimetable() async {
    final prefs = await SharedPreferences.getInstance();
    if (currentTimetable != null) {
      prefs.setString("timetableCache", jsonEncode(currentTimetable));
    }
  }

  static Future<void> getTimetable() async {
    final prefs = await SharedPreferences.getInstance();
    String? timetableCache = prefs.getString("timetableCache");
    if (timetableCache == null || timetableCache == "{}") {
      await getTimetableFromServer();
      await storeTimetable();
      return;
    }
    currentTimetable = jsonDecode(timetableCache);

    return;
  }

  factory TimetableHandler() {
    return _timetableHandler;
  }
  TimetableHandler._timetableHandlerConstructor();
}
