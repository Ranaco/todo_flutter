import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'data/models/note_model.dart';

User? user = FirebaseAuth.instance.currentUser;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class CrudFireStore {
  CrudFireStore({String? title, String? desc, String? doc});

  static addNote({String? title, String? description, var uid}) {
    CollectionReference _collect =
        FirebaseFirestore.instance.collection('notes');
    _collect.add(<String, dynamic>{
      'title': title,
      'desc': description,
      'createdAt': Timestamp.now(),
      'uid': uid,
    });
  }

  //TODO: complete the update note func;
  //TODO: complete the  delete note func;
  //TODO: complete the operation for reading;
  Future readNote() async {
    print("TEST");
    List<Note> noteData = [];
    // it shoud be: List<Note> noteData = [];
    await _firestore
        .collection('notes')
        .where('uid', isEqualTo: user!.uid)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        noteData.add(Note.fromMap(element.data()));
      });
    });

    print(noteData);

    // To Print the first json object returned from firestore

    return noteData;
  }

  static updateNote({String? title, String? description, String? doc}) {}
}
