//Firestore™

import 'package:Faire/providers/task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Firestore {
  static Firestore _firestore = Firestore._();
  FirebaseFirestore firebasefirestore = FirebaseFirestore.instance;

  factory Firestore.getInstance() {
    return _firestore;
  }
  Firestore._();

  addCategory(Category category) {
    firebasefirestore.collection("categories").add(category.toMap());
  }
  updateCategory(catId, Category category) async {
    QuerySnapshot querySnapshot = await firebasefirestore
    .collection("categories")
    .where("id", isEqualTo: catId)
    .get();
    var docId = querySnapshot.docs[0].id;
     await firebasefirestore
    .collection("categories")
    .doc(docId)
    .update(category.toMap());
  }

  removeCategory(catId) async {
    QuerySnapshot querySnapshot = await firebasefirestore
    .collection("categories")
    .where("id", isEqualTo: catId)
    .get();
    var docId = querySnapshot.docs[0].id;
     await firebasefirestore
    .collection("categories")
    .doc(docId)
    .delete();
  }
}