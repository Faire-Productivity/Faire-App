import 'package:Faire/pages/task_categories.dart';
import 'package:Faire/pages/task_list.dart';
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
  bool isLoading = false;

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
        title: Text("Faire" + context.select<TaskProvider, String>((s) =>s.currentCategoryIndex != -1 ? " - " + s.categories[s.currentCategoryIndex].name.toString() : " - Add a Category")),
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
}