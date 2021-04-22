import 'dart:convert';

import 'package:faire/services/firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

class TaskProvider with ChangeNotifier {
  Firestore _firestore = Firestore.getInstance();
  int currentCategoryIndex = -1;
  List<Category> categories = [];

  TaskProvider() {
    initCategories();
  }
  initCategories() async {
    await _firestore.firebasefirestore.collection("categories")
    .get()
    .then((d){
      d.docs.forEach((d) { 
        categories.add(Category.fromMap(d.data()));
        currentCategoryIndex = 0;
      });
    });
  }

  changeCategoryIndex(i) {
    currentCategoryIndex = i;
    notifyListeners();
  }

  addCategory(Category category) {
    categories.add(category);
    currentCategoryIndex++;
    _firestore.addCategory(category);
    notifyListeners();
  }
  addTask(String categoryId, Task task) {
    int index = categories.indexWhere((category) => category.id == categoryId);
    if (index != -1) {
      categories[index].tasks.add(task);
      _firestore.updateCategory(categories[index].id, categories[index]);
      notifyListeners();
    }
  }

  updateCategory(categoryId, name) {
    int catIndex = categories.indexWhere((c) => c.id == categoryId);
    categories[catIndex].name = name;
    _firestore.updateCategory(categoryId, categories[catIndex]);
    notifyListeners();
  }

  removeCategory(categoryId) {
    categories.removeWhere((c) => c.id == categoryId);
    currentCategoryIndex--;
    _firestore.removeCategory(categoryId);
    notifyListeners();
  }
  removeTask(categoryId, taskId) {
    int catIndex = categories.indexWhere((cat) => cat.id == categoryId);
    categories[catIndex].tasks.removeWhere((tk) => tk.id == taskId);
    _firestore.updateCategory(categoryId, categories[catIndex]);
    notifyListeners();
  }

  changeChecked(categoryId, taskId) {
    int catIndex = categories.indexWhere((cat) => cat.id == categoryId);
    int taskIndex = categories[catIndex].tasks.indexWhere((tk) => tk.id == taskId);
    categories[catIndex].tasks[taskIndex].complete = !categories[catIndex].tasks[taskIndex].complete;
    _firestore.updateCategory(categoryId, categories[catIndex]);
    notifyListeners();
  }
}

class Category {
  String id;
  String name;
  List<Task> tasks = [];

  Category({
    this.id,
    this.name,
    this.tasks,
  });

  Category copyWith({
    String id,
    String name,
    List<Task> tasks,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      tasks: tasks ?? this.tasks,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'tasks': tasks?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return Category(
      id: map['id'],
      name: map['name'],
      tasks: List<Task>.from(map['tasks']?.map((x) => Task.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Category.fromJson(String source) => Category.fromMap(json.decode(source));

  @override
  String toString() => 'Category(id: $id, name: $name, tasks: $tasks)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    final listEquals = const DeepCollectionEquality().equals;
  
    return o is Category &&
      o.id == id &&
      o.name == name &&
      listEquals(o.tasks, tasks);
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ tasks.hashCode;
}

class Task {
  String id;
  String title;
  bool complete;
  Task({
    this.id,
    this.title,
    this.complete = false,
  });

  Task copyWith({
    String id,
    String title,
    bool complete,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      complete: complete ?? this.complete,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'complete': complete,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return Task(
      id: map['id'],
      title: map['title'],
      complete: map['complete'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Task.fromJson(String source) => Task.fromMap(json.decode(source));

  @override
  String toString() => 'Task(id: $id, title: $title, complete: $complete)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is Task &&
      o.id == id &&
      o.title == title &&
      o.complete == complete;
  }

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ complete.hashCode;
}
