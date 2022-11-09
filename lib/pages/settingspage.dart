import 'package:flutter/material.dart';
import 'package:timetable_viewer/handlers/current_week_handler.dart';
import 'package:timetable_viewer/handlers/timetable_handler.dart';
import 'package:timetable_viewer/handlers/token_handler.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          TextButton(
            onPressed: () async {
              TokenHandler.loginToken = "";
              await TokenHandler.storeToken();
              TimetableHandler.currentTimetable = {};
              await TimetableHandler.storeTimetable();
              if (!mounted) return;
              Navigator.pop(context);
            },
            child: const Text("Log Out"),
          ),
        ],
      ),
    );
  }
}
