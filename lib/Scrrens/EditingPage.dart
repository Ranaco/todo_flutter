import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddOrEdit extends StatefulWidget {
  final String title;
  final int del;
  final String add;
  const AddOrEdit({
    Key? key,
    required this.title,
    required this.del,
    required this.add,
  }) : super(key: key);

  @override
  _AddOrEditState createState() => _AddOrEditState();
}

class _AddOrEditState extends State<AddOrEdit> {
  String _description = "";
  String _title = "";

  User? user = FirebaseAuth.instance.currentUser;

  Map<String, dynamic> userInput = {};

  addDataToDb() {
    CollectionReference _collectionReference =
        FirebaseFirestore.instance.collection('notes');

    setState(() {
      userInput[_title] = _description;
    });

    _collectionReference.add({
      'title': _title,
      'desc': _description,
      'createdAt': DateTime.now(),
      'uid': user!.uid,
    });
    Navigator.pop(context);
  }

  updateDb() async {
    CollectionReference _col = FirebaseFirestore.instance.collection('notes');

    _col
        .doc('UcWjfHHlSzEN7mPMTTEd')
        .update({'title': _title, 'desc': _description}).then(
            (value) => print('success'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          //The neumorphic effect
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(4, 4),
                                blurRadius: 15,
                                spreadRadius: 3,
                                color: Colors.grey.shade500),
                            BoxShadow(
                                offset: Offset(-4, -4),
                                blurRadius: 15,
                                spreadRadius: 3,
                                color: Colors.grey.shade300)
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(70))),
                      child: Icon(Icons.arrow_back_ios_new_rounded),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    widget.title,
                    style: GoogleFonts.allerta(
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.2,
              ),
              SingleChildScrollView(
                  child: SizedBox(
                height: MediaQuery.of(context).size.width * 0.8,
                width: MediaQuery.of(context).size.width * 0.8,
                child: SingleChildScrollView(
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    elevation: 20,
                    child: SingleChildScrollView(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: MediaQuery.of(context).size.width * 0.1,
                            ),
                            ListTile(
                              leading: Icon(Icons.title),
                              title: TextFormField(
                                decoration: InputDecoration(
                                  hintText: 'Enter title',
                                ),
                                onChanged: (title) {
                                  _title = title;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ListTile(
                              leading: Icon(Icons.description),
                              title: TextFormField(
                                decoration: InputDecoration(
                                    hintText: 'Enter description'),
                                onChanged: (desc) {
                                  _description = desc;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            widget.del == 1
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      ElevatedButton(
                                        onPressed: updateDb(),
                                        child: Text(
                                          widget.add,
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                            elevation: 10,
                                            primary: Colors.grey.shade200,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10))),
                                      ),
                                      (ElevatedButton(
                                        onPressed: () {},
                                        child: Text(
                                          'Delete',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                            elevation: 10,
                                            primary: Colors.red.shade200,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10))),
                                      ))
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                        ElevatedButton(
                                          onPressed: addDataToDb,
                                          child: Text(
                                            widget.add,
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                              elevation: 10,
                                              primary: Colors.grey.shade200,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10))),
                                        ),
                                      ]),
                          ]),
                    ),
                  ),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
