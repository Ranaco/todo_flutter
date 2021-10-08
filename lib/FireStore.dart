import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreDb {
  static Future getAllTheDocs() async {
    final snapshot = await FirebaseFirestore.instance.collection('notes').get();
    var list = snapshot.docs;
    print(list);
  }
}
