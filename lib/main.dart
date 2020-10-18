import 'package:Faire/pages/home.dart';
import 'package:Faire/providers/task.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
          child: MaterialApp(
        title: 'Faire',
        theme: ThemeData(
          fontFamily: GoogleFonts.montserrat().fontFamily,
          primarySwatch: Colors.pink,
          // to be impemented on 0.1.2
          // primaryColor: Color(0xfff50057),
          // accentColor: Color(0xffffbc0a),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Homepage(),
      ),
    );
  }
}

