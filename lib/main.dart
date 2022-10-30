import 'package:flutter/material.dart';
import 'package:timetable_viewer/handlers/current_week_handler.dart';
import 'package:timetable_viewer/handlers/timetable_handler.dart';
import 'package:timetable_viewer/pages/loginpage.dart';
import 'package:timetable_viewer/widgets/day.dart';
import 'package:timetable_viewer/widgets/week.dart';
import 'handlers/token_handler.dart';

Map? timetable;
final List<String> days = ["Mon", "Tue", "Wed", "Thu", "Fri"];
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Timetable Viewer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Timetable Viewer'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final nonHighlightedDecoration = const BoxDecoration();
  final highlightedDecoration = BoxDecoration(
    border: Border.all(
      width: 1,
      color: Colors.blue,
    ),
  );

  Future<void> onStart() async {
    String? cachedToken = await TokenHandler.loadCachedToken();
    if (cachedToken == null && mounted) {
      await Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => const LoginPage(),
        ),
      );
    }
    await TimetableHandler.getTimetable();
    await CurrentWeekHandler.getCurrentWeek();
    setState(() {
      timetable = TimetableHandler.currentTimetable;
    });
  }

  @override
  void initState() {
    super.initState();
    onStart();
  }

  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final List<Widget?> widgets = timetable != null
        ? [
            DateTime.now().weekday > 5 == false
                ? DayDisplay(
                    dayNum: DateTime.now().weekday - 1,
                    weekNum: CurrentWeekHandler.currentWeek + 1,
                    timetable: timetable!,
                  )
                : null,
            ListView(
              children: [
                WeekDisplay(
                  timetable: timetable!,
                  weekNum: CurrentWeekHandler.currentWeek + 1,
                ),
              ],
            ),
            ListView(
              children: [
                WeekDisplay(
                  weekNum: CurrentWeekHandler.currentWeek == 0 ? 2 : 1,
                  timetable: timetable!,
                ),
              ],
            )
          ]
        : [];
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),

      body: widgets.length == 3
          ? widgets[_currentIndex]
          : const Text("Couldn't load timetable"),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.language,
              color: Colors.black,
            ),
            label: "Today",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.language,
              color: Colors.black,
            ),
            label: "Current Week",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.language,
              color: Colors.black,
            ),
            label: "Next Week",
          ),
        ],
        currentIndex: _currentIndex,
        onTap: (newIndex) {
          setState(() {
            _currentIndex = newIndex;
          });
        },
        selectedItemColor: Colors.blue,
        backgroundColor: Colors.white,
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
