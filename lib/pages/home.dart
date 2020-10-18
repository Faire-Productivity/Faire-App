import 'package:Faire/pages/settings.dart';
import 'package:Faire/pages/task_categories.dart';
import 'package:Faire/pages/task_list.dart';
import 'package:Faire/services/popup_constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:Faire/providers/task.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
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
        Text(context.select<TaskProvider, String>((s) =>s.currentCategoryIndex != -1 ? s.categories[s.currentCategoryIndex].name.toString() : "Faire")),
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
        child: TaskCategoryView(),
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
}