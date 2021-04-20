import 'package:Faire/pages/home.dart';
import 'package:Faire/providers/task.dart';
import 'package:Faire/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TaskProvider>(
      create: (context) => TaskProvider(),
      child: ChangeNotifierProvider<ThemeNotifier>(
        create: (context) => ThemeNotifier(),
        child: Consumer<ThemeNotifier>(
          builder: (context, ThemeNotifier notifier, child) {
            return MaterialApp(
              title: 'Faire',
              theme: notifier.darkMode ? darkMode : brightMode,
              home: Homepage(),
            );
          },
        ),
      ),
    );
  }
}

