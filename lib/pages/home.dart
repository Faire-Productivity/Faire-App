import 'package:faire/pages/settings.dart';
import 'package:faire/pages/task_list.dart';
import 'package:faire/providers/theme_provider.dart';
import 'package:faire/utils/dialogs.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:faire/providers/task.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homepage extends StatefulWidget {

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  SharedPreferences _prefs;
  bool _init = false;
  bool _err = false;

  void initFirebase() async {
    try {
      await Firebase.initializeApp();
      setState(() {
        _init = true;
      });
    } catch(e) {
      setState(() {
        _err = true;
      });
      print(e);
    }
  }

  @override
  void initState() {
    _initPrefs();
    initFirebase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(_err) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Error - Firebase"),
        ),
        body: Container(
          alignment: Alignment.center,
          child: Text("Error, check initFirebase() function."),
        ),
      );
    }
    if(!_init) {
      return Center(child: CircularProgressIndicator(),);
    }
    return Scaffold(
      appBar: AppBar(
        title:
        Text(context.select<TaskProvider, String>((s) =>s.currentCategoryIndex != -1 ? s.categories[s.currentCategoryIndex].name.toString() : "<= No Task Loaded")),
        actions: [
          PopupMenuButton<String>(
            onSelected: choicesAction,
            itemBuilder: (BuildContext context) {
              return PopUpConstants.popupChoices.map((String popupChoice){
                return PopupMenuItem<String>(
                  value: popupChoice,
                  child: Text(popupChoice),
                );
              }).toList();
            },
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Theme.of(context).accentColor,
                    createMaterialColor(Color(0xffe91e63))
                  ]
                )
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 200,
                  ),
                  FractionallySizedBox(
                    widthFactor: 0.75,
                    child: Image.asset("assets/faire_greytext_4k.png", height: 100, color: Color(0xfff2f2f2),),
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                            "Categories (" + context.read<TaskProvider>().categories.length.toString() + ")",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: GoogleFonts.montserrat().fontFamily
                          ),
                        ),
                        trailing: TextButton(
                          style: ButtonStyle(
                            alignment: Alignment.centerRight
                          ),
                          onPressed: () {
                            showAddCategory(context);
                          },
                          child: Icon(Icons.add, color: Theme.of(context).primaryColor,),
                        ),
                        ),
                    ),
                ],
              )
              ),
                Consumer<TaskProvider>(
                  builder: (context, value, child) => ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: value.categories.length,
                    itemBuilder: (context, index) => ListTile(
                      onTap: () {
                        value.changeCategoryIndex(index);
                        Navigator.pop(context);
                      },
                      onLongPress: () {
                        value.changeCategoryIndex(index);
                        showAddCategory(context, edit: true);
                      },
                      selected: value.currentCategoryIndex == index? true : false,
                      leading: Icon(Icons.list_alt),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(child: Text(value.categories[index].name,)),
                          Text(value.categories[index].tasks.where((t) => t.complete).length.toString() + " / " + value.categories[index].tasks.length.toString(),),
                        ],
                      ),
                    ),
                  ),
                ),
            // since you can add a category beside the "Category(n)",
            // commenting this in case of emergency

            // ListTile(
            //   onTap: () {
            //     showAddCategory(context);
            //   },
            //   leading: Icon(Icons.add),
            //   title: Text("Add a Category"),
            // ),
          ],
        ),
      ),
      body: Row(
        children: [
          Expanded(
              child: TaskList()
          )
        ],
      ),
    );
  }
  void choicesAction(String popupChoice) {
    if (popupChoice == PopUpConstants.Settings) {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => SettingsPage()
      ));
    }
  }
  _initPrefs() async {
    if(_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
    _prefs.getBool(ThemeNotifier().key);
    print(_prefs.getBool(ThemeNotifier().key).toString() + " <= current bool");
  }
}

class PopUpConstants {
  static const String Settings = "Settings";

  static const List<String> popupChoices = <String>[
    Settings
  ];
}