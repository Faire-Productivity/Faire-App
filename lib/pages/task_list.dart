import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:faire/providers/task.dart';

class TaskList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            if (context.select<TaskProvider, int>(
                    (state) => state.currentCategoryIndex) !=
                -1)
              ListTile(
                onTap: () {
                  showAddTask(context);
                },
                leading: Icon(Icons.add),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Add Task"),
                  ],
                ),
              ),
            Expanded(child: Consumer<TaskProvider>(
              builder: (context, value, child) {
                if (value.categories.isNotEmpty)
                  return ListView.builder(
                      itemCount: value
                          .categories[value.currentCategoryIndex].tasks.length,
                      itemBuilder: (context, index) {
                        var taskItem =
                            value.categories[value.currentCategoryIndex];
                        return CheckboxListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            onChanged: (t) {
                              value.changeChecked(
                                  taskItem.id, taskItem.tasks[index].id);
                            },
                            value: taskItem.tasks[index].complete,
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    taskItem.tasks[index].title,
                                    style: TextStyle(
                                      // fontWeight: FontWeight.bold,
                                      decoration: taskItem.tasks[index].complete
                                          ? TextDecoration.lineThrough
                                          : null,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    value.removeTask(taskItem.id, taskItem.tasks[index].id);
                                  },
                                  icon: Icon(Icons.delete, color: Colors.grey)
                                ),
                              ],
                            ));
                      });
                else
                  return Container();
              },
            )),
          ],
        ),
      ),
    );
  }

  showAddTask(context) {
    String inputText;
    GlobalKey<FormState> _formKey = GlobalKey();
    showDialog(
        context: context,
        builder: (context) => Form(
              key: _formKey,
              child: AlertDialog(
                title: Text("Add Task"),
                content: TextFormField(
                    onSaved: (text) {
                      inputText = text;
                    },
                    validator: (text) {
                      if (text.isEmpty) {
                        return "Task name can't be empty!";
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        hintText: "e.g. 'Finish this damn app'")),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Cancel")),
                  TextButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          var read = context.read<TaskProvider>();
                          read.addTask(
                            read.categories[read.currentCategoryIndex].id,
                            Task(
                              id: UniqueKey().toString(),
                              title: inputText,
                            ),
                          );
                          Navigator.pop(context);
                        }
                      },
                      child: Text("Add"))
                ],
              ),
            ));
  }
}
