import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/retry.dart';

import 'data/models/note_model.dart';

User? user = FirebaseAuth.instance.currentUser;

class CrudFireStore {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CrudFireStore({String? title, String? desc, String? doc});

  static Future<Note> addNote(Note note) async {
    var newdoc = await _firestore.collection('notes').add(note.toMap());
    return note..docId = newdoc.id;
  }

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
        noteData
            .add(Note.fromMap(element.data(), element.id)); //okay gotcha good
      });
    });

    return noteData;
  }

  static updateNote(Note note) async {
    await _firestore
        .collection('notes')
        .doc(note.docId)
        .update(note.toMap()); //oh
  }
}
