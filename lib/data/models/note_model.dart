import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  String title;
  String desc;
  final String uid;
  String? docId;

  Note(
      {required this.title,
      required this.desc,
      required this.uid,
      required this.docId});

  factory Note.fromMap(Map<String, dynamic> map, String docId) {
    return Note(
      title: map['title'],
      desc: map['desc'],
      uid: map['uid'],
      docId: docId,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'title': title,
      'desc': desc,
    }; // so atleast do what i am telling, later try to understand it
  } //so now what to do? step 2? it's done??i dont see it

  @override
  String toString() {
    return ('title: $title, desc: $desc, uid: $uid, docId: $docId\n');
  }
}
