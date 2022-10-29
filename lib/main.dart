import 'package:flutter/material.dart';
import 'package:timetable_viewer/handlers/current_week_handler.dart';
import 'package:timetable_viewer/handlers/timetable_handler.dart';
import 'package:timetable_viewer/widgets/day.dart';
import 'package:timetable_viewer/widgets/week.dart';
import 'handlers/token_handler.dart';

late Map? timetable;
final List<String> days = ["Mon", "Tue", "Wed", "Thu", "Fri"];
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await TokenHandler.loadCachedToken();
  await TimetableHandler.getTimetable();
  await CurrentWeekHandler.getCurrentWeek();
  timetable = TimetableHandler.currentTimetable;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Timetable Viewer',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Timetable Viewer'),
    );
  }
}

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
              weekNum: 1,
            ),
          ],
        ),
        ListView(
          children: [
            WeekDisplay(
              weekNum: 2,
              timetable: timetable!,
            ),
          ],
        )
      ]
    : [];

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

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

  @override
  void initState() {
    super.initState();
  }

  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
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
