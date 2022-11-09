import "package:http/http.dart" as http;
import 'package:timetable_viewer/handlers/token_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:week_of_year/week_of_year.dart';

class CurrentWeekHandler {
  static int currentWeek = 0;
  static Future<int> getCurrentWeekFromServer() async {
    final res = await http.get(Uri.parse("https://genie.hartismere.com/"),
        headers: {'Cookie': 'HFOS_USR=${TokenHandler.loginToken}'});
    const String pattern = '<div class="content ';
    int index = res.body.lastIndexOf(pattern) + pattern.length;
    String weekString = res.body.substring(index, index + 5);
    int weekNum = weekString == "week1" ? 0 : 1;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("weekOfYearCache", DateTime.now().weekOfYear);
    prefs.setInt("currentWeekCache", weekNum);
    return weekNum;
  }

  static Future<int> getCurrentWeek() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? weekOfYearCache = prefs.getInt("weekOfYearCache");
    if (weekOfYearCache == DateTime.now().weekOfYear) {
      int weekNum = prefs.getInt("currentWeekCache")!;
      currentWeek = weekNum;
      return (weekNum);
    }
    int weekNum = await getCurrentWeekFromServer();
    currentWeek = weekNum;
    return weekNum;
  }
}
