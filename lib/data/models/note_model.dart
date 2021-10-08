// Note Data Model Class
import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String uid;
  final DateTime createdAt;
  final String title;
  final String desc;

  Note(
      {required this.uid,
      required this.createdAt,
      required this.title,
      required this.desc});

  // TO convert JSON object to Note object
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      uid: map['uid'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      title: map['title'],
      desc: map['desc'],
    );
  }

  // To convert Note object to Map object
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'createdAt': Timestamp.fromDate(createdAt),
      'title': title,
      'desc': desc,
    };
  }

  @override
  String toString() {
    return 'Note{uid: $uid, createdAt: $createdAt, title: $title, desc: $desc}';
  }
}
