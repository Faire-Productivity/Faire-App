import 'package:Faire/providers/task.dart';
import 'package:Faire/utils/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskCategoryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Categories (${context.watch<TaskProvider>().categories.length.toString()})"),
                FlatButton(
                  onPressed: () {
                    showAddCategory(context, edit: true);
                  },
                  child: Text("Edit"),
                )
              ],
            ),
          ),
          // if(context.read<TaskProvider>().categories.length > 0)
          Expanded(
            child: Consumer<TaskProvider>(
              builder: (context, value, child) => ListView.builder(
                itemCount: value.categories.length,
                itemBuilder: (context, index) => ListTile(
                  onTap: () {
                    value.changeCategoryIndex(index);
                    Navigator.pop(context);
                  },
                  selected: value.currentCategoryIndex == index? true : false,
                  leading: Icon(Icons.list_alt),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(value.categories[index].name),
                      Text(value.categories[index].tasks.where((t) => t.complete).length.toString() + " / " + value.categories[index].tasks.length.toString()),
                    ],
                    ),
                ),
              ),
            ),
          ),
          ListTile(
            onTap: () {
              showAddCategory(context);
            },
            leading: Icon(Icons.add),
            title: Text("Add a Category"),
          ),
        ],
      )),
    );
  }

}
