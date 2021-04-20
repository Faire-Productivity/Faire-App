import 'package:flutter/material.dart';
import 'package:Faire/providers/task.dart';
import 'package:provider/provider.dart';

showAddCategory(context, {edit = false}) {
  TextEditingController tect = TextEditingController();
  String inputText;
  GlobalKey<FormState> _formKey = GlobalKey();
  showDialog(
      context: context,
      builder: (context) {
        var name = context.select<TaskProvider, String>((s) =>s.currentCategoryIndex != -1 ? s.categories[s.currentCategoryIndex].name : null);
                tect.text =edit? name:null;
        return Form(
            key: _formKey,
            child: AlertDialog(
              title: Text(edit ? "Update Category" : "Add Category"),
              content: TextFormField(
                controller: tect,
                  onSaved: (text) {
                    inputText = text;
                  },
                  validator: (text) {
                    if (text.isEmpty) {
                      return "Category can't be empty!";
                    } else {
                      return null;
                    }
                  },
                  decoration:
                      InputDecoration(hintText: "e.g. 'Work', 'Personal'")),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                        "Cancel",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    )),
                if (edit)
                TextButton(
                        onPressed: () {
                          showDeleteDialog(context, task: false);

                        },
                        child: Text(
                          "Delete",
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        )),
                TextButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        if(!edit) {
                          context.read<TaskProvider>().addCategory(Category(
                              id: UniqueKey().toString(),
                              name: inputText,
                              tasks: []));
                        } else {
                          var read = context.read<TaskProvider>();
                          var catId = read.categories[read.currentCategoryIndex].id;
                          context.read<TaskProvider>().updateCategory(catId, inputText);
                        }
                        Navigator.pop(context);
                      }
                    },
                    child: Text(edit ? "Update" : "Add"))
              ],
            ),
          );
      });
}

showDeleteDialog(context, {task = false}) {
  task ? print("task is positive, skipping Navigator.pop().") : Navigator.pop(context);
  showDialog(
    context: context,
    builder: (context) {
      var name = context.select<TaskProvider, String>((s) =>s.currentCategoryIndex != -1 ? s.categories[s.currentCategoryIndex].name : null);
      return AlertDialog(
        content: Text(task ? "Are you sure you want to delete this task?" : "Are you sure you want to delete \"$name?\""),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.grey,
                ),
              )),
          TextButton(
            onPressed: () {
              var read = context.read<TaskProvider>();
              var catId = read.categories[read.currentCategoryIndex].id;
              read.removeCategory(catId);
              Navigator.pop(context);
            },
            child: Text(
              "Delete",
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          )
        ],
      );
    }
  );

}