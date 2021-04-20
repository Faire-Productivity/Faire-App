import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}


ThemeData brightMode = ThemeData(
  brightness: Brightness.light,
  primarySwatch: createMaterialColor(Color(0xffe91e63)),
  accentColor: createMaterialColor(Color(0xffffc400)),
  scaffoldBackgroundColor: Color(0xfff2f2f2),
  fontFamily: GoogleFonts.montserrat().fontFamily,
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: createMaterialColor(Color(0xffe91e63)),
  accentColor: createMaterialColor(Color(0xffc79400)),
  fontFamily: GoogleFonts.montserrat().fontFamily
);

class ThemeNotifier extends ChangeNotifier {
  final String key = "themeKey";
  SharedPreferences _prefs;
  bool _darkMode;
  bool get darkMode => _darkMode;
  ThemeNotifier() {
    _darkMode = true;
    _loadFromPrefs();
  }
  toggleTheme(){
    _darkMode = !_darkMode;
    notifyListeners();
    _saveToPrefs();
    print("darkMode is now set to " + _darkMode.toString());
  }
  _initPrefs() async {
    if(_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
  }
  _loadFromPrefs() async {
    await _initPrefs();
    _darkMode = _prefs.getBool(key) ?? true;
    notifyListeners();
  }
  _saveToPrefs() async {
    await _initPrefs();
    _prefs.setBool(key, _darkMode);
  }
}